class RecurringEntry < ActiveRecord::Base
  belongs_to :ledger
  belongs_to :category
  has_many :entries
  after_create :insert_entries
  before_destroy :remove_future_entries
  default_scope order("day_of_month ASC")

  def as_json(options={})
    {
      :id           => id,
      :category     => category.name,
      :day_of_month => day_of_month,
      :payee        => payee,
      :period       => period
    }
  end

  def num_weeks
    @num_weeks ||= case period
      when "Monthly" then 4
      when "Weekly" then 1
      when "Bi-Weekly" then 2
    end
  end

  private

    def insert_entries
      (self.times).times do |i|
        if period == "Monthly"
          curr_date = start_date + i.months
        else
          curr_date = start_date + (i * num_weeks).weeks
        end

        entries.create({
          :date        => curr_date,
          :amount      => amount,
          :memo        => "#{memo} (#{i+1}/#{times})",
          :payee       => payee,
          :category_id => category.id,
          :ledger_id   => ledger.id
        })
      end
    end

    def remove_future_entries
      entries.where("entries.date > '#{Date.today}'").destroy_all
    end

end
