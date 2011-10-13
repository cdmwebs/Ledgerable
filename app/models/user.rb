class User < ActiveRecord::Base

  has_many :ledgers, :dependent => :destroy

  def todays_value
    ledgers.map(&:todays_value).sum
  end

  def ledger_names
    ledgers.map(&:name)
  end

  def ledger_overview
    ledgers.map(&:overview_data)
  end

  def overview_chart_data
    # [date, L1, L2, ... Ln]
    dates = (30.days.ago.to_date..Date.today.to_date).to_a

    days = dates.inject([]) do |stack, day|
      stack << [day.strftime('%m/%d')]
    end

    ledgers.each do |ledger|
      curr_value = ledger.total_on_date(31.days.ago)
      entries    = ledger.past_thirty_days

      dates.each_with_index do |date, i|
        amount = entries.select{|e| e.date == date}.sum(&:amount)
        curr_value += amount
        days[i] << curr_value.floor
      end
    end

    days
  end

  def net_worth
    ledgers.map(&:todays_value).sum
  end

end
