Factory.sequence :email do |n|
  "person#{n}@somewhere.net"
end

Factory.define :user do |e|
  e.email { Factory.next(:email) }
end

Factory.define :entry do |t|
  t.date Date.parse("2010-11-19")
  t.payee "Payee"
  t.memo "Memo"
  t.amount 1.0
  t.category_id 1
  t.ledger_id 1
  t.recurring_entry_id nil
end

Factory.define :category do |c|
  c.name "Category"
  c.ledger_id 1
end

Factory.define :ledger do |l|
  l.name "Ledger"
  l.user_id 1
  l.processing false
end

Factory.define :recurring_entry do |r|
  r.ledger_id 1
  r.period "Monthly"
  r.start_date Date.parse("2010-11-26")
  r.amount 1.0
  r.payee "Payee"
  r.times 10
  r.category_id 1
  r.memo "Memo"
  r.day_of_month 26
end
