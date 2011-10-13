class Entry < ActiveRecord::Base

  belongs_to :ledger
  belongs_to :category
  default_scope order("date DESC, amount ASC")

  def to_qif
    str  = "^\n"
    str += "D#{date.strftime('%m/%d/%Y')}\n"
    str += "P#{payee}\n"
    str += "T#{amount}\n"
    str += "M#{memo}\n"
    str += "L#{category.name}\n"
    str += "C#{'X' if cleared?}"
  end

  def as_json(options = {})
    {
      :date       => date,
      :payee      => payee,
      :memo       => memo,
      :amount     => amount,
      :status     => status,
      :created_at => created_at,
      :updated_at => updated_at,
      :category   => category.name,
      :id         => id,
      :ledger_id  => ledger_id
    }
  end

  def cleared!
    update_attribute(:status, "Cleared")
  end

  def uncleared!
    update_attribute(:status, "Open")
  end

  def cleared?
    status == "Cleared"
  end

  def amount=(value)
    write_attribute(:amount, value.to_s.gsub(/[\$,]/, '').to_f)
  end

end
