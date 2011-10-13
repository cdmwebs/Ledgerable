class Category < ActiveRecord::Base

  belongs_to :ledger
  has_many :entries
  default_scope :order => "name ASC"

  def as_json(options = {})
    {
      :name       => name,
      :id         => id,
      :ledger_id  => ledger_id,
      :created_at => created_at,
      :updated_at => updated_at
    }
  end

end
