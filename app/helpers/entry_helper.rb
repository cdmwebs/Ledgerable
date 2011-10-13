module EntryHelper

  def status_css(t)
    str = t.status.downcase
    str << " posted" if t.date <= Date.today
    str << " today" if t.date == Date.today
    str << " future" if t.date > Date.today
    str << " debit" if t.amount < 0.0
    str << " credit" if t.amount > 0.0
    str
  end

end
