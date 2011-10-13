class SearchesController < ApplicationController

  def show
    @ledger = ledger
  end

  def create
    @ledger = ledger
    @entries = @ledger.search(params[:search])
  end

  protected

  def ledger
    @ledger ||= Ledger.find_by_id(params[:ledger_id])
  end

end
