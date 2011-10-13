module RecurringTransactionsHelper

  def colorized(t)
    if t.amount > 0.0
      glue = 'from'
      css = "credit"
    else
      glue = 'to'
      css = "debit"
    end

    if t.period == "Monthly"
      str = t.day_of_month.ordinalize
    else
      str = "#{t.num_weeks} "
      str += (t.num_weeks == 1) ? "week" : "weeks"
    end

    <<-STR
      <span class="value">$#{t.amount}</span>
      #{glue} <strong>#{t.payee}</strong> every #{str}
    STR
  end

end
