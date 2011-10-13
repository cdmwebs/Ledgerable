require 'gchart'

class MonthlyExpensesChart

  def initialize(ledger, style = :current_month)
    @ledger = ledger
    @style  = style
    @total  = 0.0
    set_dates
  end

  def img_src
    data = values

    Gchart.pie_3d({
      :title       => title,
      :size        => '600x250',
      :data        => data.map{|h| h[:value]},
      :labels      => data.map{|h| h[:label]},
      :line_colors => '0077CC',
      :bg_color    => 'FFFFFF00'
    })
  end

  def totals
    values = entries.inject([]) do |s, (category, entries)|
      value = entries.map(&:amount).sum
      @total += value
      s << { :label => category.name, :value => value }
    end

    @total = @total * -1

    values
  end

  def percentages
    totals.inject([]) do |s, hash|
      percentage = ((hash[:value] * -1) / @total) * 100
      s << { :label => hash[:label], :value => percentage}
    end
  end

  def values
    return @big if defined?(@big)

    @big = []
    little = []

    percentages.each do |hash|
      if hash[:value] > 2.0
        @big << hash
      else
        little << hash
      end
    end

    little_value = little.inject(0.0) do |stack, hash|
      stack += hash[:value]
    end

    @big << {:label => "Other", :value => little_value}
  end

  private

    def title
      case @style
        when :current_month then "Current Monthly Expenses"
        when :last_three_months then "Last Three Months Expenses"
        when :current_year then "Current Year Expenses"
      end
    end

    def set_dates
      if @style == :current_month
        @start_date = Date.today.beginning_of_month
        @end_date   = Date.today.end_of_month
      elsif @style == :last_three_months
        @start_date = 3.months.ago.beginning_of_month
        @end_date   = Date.today.end_of_month
      elsif @style == :current_year
        @start_date = Date.today.beginning_of_year
        @end_date   = Date.today.end_of_month
      end
    end

    def sql
      "date >= '#{@start_date}' and date <= '#{@end_date}' and amount < 0.0"
    end

    def entries
      @entries ||= @ledger.entries.where(sql).includes(:category).group_by(&:category)
    end

end