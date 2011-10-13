require 'digest/sha1'
require 'ostruct'

class Ledger < ActiveRecord::Base

  belongs_to :user
  has_many :entries, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :recurring_entries, :dependent => :destroy
  default_scope order("name ASC")

  def to_s
    name
  end

  def as_json(options={})
    {
      :id             => id,
      :name           => name,
      :todays_value   => todays_value,
      :starting_value => one_year_window_start_value
    }
  end

  def todays_value
    total_on_date(Date.today)
  end

  def total_on_date(date)
    entries.where(["date <= ?", date.to_date]).sum("amount").round(2)
  end

  def one_year_window
    entries_during_date_range(((11.month.ago)...(1.month.from_now)))
  end

  def one_year_window_start_value
    total_on_date(11.month.ago - 1.day)
  end

  def past_thirty_days
    sd = 1.month.ago.beginning_of_day
    ed = Date.today.end_of_day
    entries_during_date_range((sd...ed))
  end

  def past_ninety_days
    sd = 90.days.ago.beginning_of_day
    ed = Date.today.end_of_day
    entries_during_date_range((sd...ed))
  end

  def entries_during_date_range(range)
    first = range.first.to_date
    last  = range.last.to_date
    entries.where(["date BETWEEN ? AND ?", first, last]).includes(:category)
  end

  def past_thirty_days_amount(style)
    str = (style == :credit) ? ">" : "<"
    past_thirty_days.where("entries.amount #{str} 0.0").sum("amount")
  end

  def last_two_weeks
    range = ((2.weeks.ago)..(Date.today))
    entries_during_date_range(range)
  end

  def to_qif
    entries.includes(:category).map(&:to_qif).join("\n")
  end

  def payees(term)
    entries.where(["lower(payee) like ?", "%#{term.downcase}%"]).map{|t| t.payee}.uniq
  end

  def category_list(term)
    categories.where(['lower(name) like ?', "%#{term.downcase}%"]).map{|c| c.name}
  end

  def last_category_for(payee)
    begin
      entries.where(["lower(payee) like ?", "%#{payee.downcase}%"]).take(1).first.category.name
    rescue
      ""
    end
  end

  def search(params)
    p = OpenStruct.new(params)

    e = entries.includes(:category)
    e = e.where(["entries.date >= ?", p.start_date]) if p.start_date.present?
    e = e.where(["entries.date <= ?", p.end_date]) if p.end_date.present?
    e = e.where(["entries.amount = ?", p.amount]) if p.amount.present?
    e = e.where(["lower(entries.payee) like ?", "%#{p.payee.downcase}%"]) if p.payee.present?
    e = e.where(["lower(entries.memo) like ?", "%#{p.memo.downcase}%"]) if p.memo.present?
    e = e.where(["lower(categories.name) like ?", "%#{p.category.downcase}%"]) if p.category.present?

    e
  end

  def overview_data
    val = '%.2f' % todays_value
    {:id => id, :name => name, :value => "$#{val}"}
  end

end
