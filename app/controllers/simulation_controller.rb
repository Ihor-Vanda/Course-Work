require_relative '../../lib/interval_method'
require_relative '../../lib/neiman_method'
require_relative '../../lib/metropolis_method'
require_relative '../../lib/math_f'
require 'json'
include MathF
class SimulationController < ApplicationController
  def simulate
    respond_to do |format|
      format.zip do
        save_data
      end
      format.html do
        @lambda = params[:lambda].to_f
        @count = params[:count].to_i
        @k = params[:k].to_i

        @pmf_distribution = get_pmf_distribution(@lambda, @k)
        @theory = {
          'mode' => get_mode_theory(@lambda),
          'expected_value' => get_expected_value_theory(@lambda),
          'dispersion' => get_dispersion_theory(@lambda),
          "lambda" => @lambda,
          "n" => @count
        }

        interval_m = IntervalMethod.new
        @interval_method_hash = interval_m.generate(@lambda, @k, @count)
        e_v = get_expected_value(@interval_method_hash)
        @interval_method = {
          'mode' => get_mode(@interval_method_hash),
          'expected_value' => e_v,
          'dispersion' => get_dispersion(@interval_method_hash, e_v),
          "lambda" => @lambda,
          "n" => @count
        }

        neiman_method = NeimanMethod.new
        @neiman_method_hash = neiman_method.generate(@lambda, @k, @count)
        e_v = get_expected_value(@neiman_method_hash)
        @neiman_method = {
          'mode' => get_mode(@neiman_method_hash),
          'expected_value' => e_v,
          'dispersion' => get_dispersion(@neiman_method_hash, e_v),
          "lambda" => @lambda,
          "n" => @count
        }

        metropolis_method = NeimanMethod.new
        @metropolis_method_hash = metropolis_method.generate(@lambda, @k, @count)
        e_v = get_expected_value(@metropolis_method_hash)
        @metropolis_method = {
          'mode' => get_mode(@metropolis_method_hash),
          'expected_value' => e_v,
          'dispersion' => get_dispersion(@metropolis_method_hash, e_v),
          "lambda" => @lambda,
          "n" => @count
        }

        @data = {
          "theory" => [@pmf_distribution, @theory],
          "interval_m" => [@interval_method_hash, @interval_method],
          "neiman_m" => [@neiman_method_hash, @neiman_method],
          "metropolis_m" => [@metropolis_method_hash, @metropolis_method],
        }
        export_to_file
      end
    end
  end

  def export
    send_file "data.xlsx", :disposition => 'attachment' if File.exist?("data.xlsx")
  end

  private

  def export_to_file
    Axlsx::Package.new do |p|
      @data.keys.each do |key|
        p.workbook.add_worksheet(:name => "#{key}") do |sheet|
          values = @data[key]
          hash = values[0]
          param = values[1]
          sheet.add_row(["λ = ", param['lambda'],  "n = ", param['n']])
          sheet.add_row(["k", "P(k)"])
          hash.each do |k, v|
            sheet.add_row([k, "%0.5f" % v])
          end
          sheet.add_row(%w{ })
          sheet.add_row(["Expected value:", "%0.5f" % param['expected_value']])
          sheet.add_row(["Mode:", "%0.5f" % param['mode']])
          sheet.add_row(["Dispersion:", "%0.5f" % param['dispersion']])
        end
      end
      p.serialize('data.xlsx', 'w+')
    end
  end
end
