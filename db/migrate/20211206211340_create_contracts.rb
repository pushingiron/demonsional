class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.string :contract_name
      t.string :owner
      t.boolean :web_service
      t.string :service
      t.decimal :service_days
      t.string :mode
      t.date :effective_date
      t.date :expiration_date
      t.string :type
      t.boolean :is_multi_stop
      t.boolean :disable_distance_non_mg
      t.boolean :disable_distance_mg
      t.boolean :is_gain_share
      t.string :discount_type
      t.decimal :discount_flat_value
      t.boolean :smc_min_dis_enabled
      t.decimal :minimum
      t.string :re_rate_date_type
      t.string :distance_determiner
      t.string :distance_route_type
      t.decimal :transit_time
      t.string :weekend_holiday_adj
      t.boolean :oversize_charges
      t.boolean :show_zero
      t.decimal :dim_factor
      t.string :dim_weight_calc
      t.boolean :dimensional_rounding
      t.decimal :dim_weight_min_cube
      t.boolean :include_rto_miles
      t.boolean :require_deimensions
      t.decimal :qty_density_weight
      t.boolean :do_not_return_indirect_charges
      t.decimal :uplift_per
      t.string :uplift_type
      t.decimal :uplift_min
      t.decimal :uplift_max
      t.boolean :exclude_pct_acc_from_uplift
      t.decimal :uplift

      t.timestamps
    end
  end
end
