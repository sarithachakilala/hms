# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120709133302) do

  create_table "admissions", :force => true do |t|
    t.integer  "user_id"
    t.string   "admn_category"
    t.string   "org_code"
    t.string   "org_location"
    t.string   "registration_id"
    t.date     "admn_date"
    t.string   "mr_no"
    t.string   "admn_no"
    t.string   "admn_status"
    t.string   "patient_name"
    t.integer  "age"
    t.string   "gender"
    t.string   "admn_type"
    t.string   "authorized_police_station"
    t.string   "case_type"
    t.string   "fir_no"
    t.string   "department"
    t.string   "consultant_id"
    t.string   "consultant_name"
    t.string   "ward"
    t.string   "room"
    t.string   "bed"
    t.string   "floor"
    t.string   "attendant_name"
    t.string   "attendant_ph_no"
    t.string   "package_category"
    t.string   "sub_category"
    t.string   "days"
    t.string   "amount"
    t.string   "advance"
    t.string   "bill_no1"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advance_payments", :force => true do |t|
    t.string   "mr_no"
    t.string   "admn_no"
    t.date     "advance_date"
    t.float    "total_amount"
    t.float    "gross_amount"
    t.float    "already_paid_amount"
    t.integer  "receipt_no"
    t.string   "payment_mode"
    t.string   "bank_name"
    t.string   "acc_no"
    t.string   "cheque_no"
    t.string   "card_no"
    t.string   "card_type"
    t.date     "expiry_date"
    t.float    "card_amount"
    t.float    "cheque_amount"
    t.string   "admn_category"
    t.string   "org_code"
    t.string   "org_location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agency_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "agency_name"
    t.string   "agency_dl_no",           :null => false
    t.string   "agency_tin_no"
    t.string   "vat_no"
    t.string   "list_of_items_supplied"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "contact_person"
    t.string   "agency_email"
    t.string   "contact_no"
    t.string   "status"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_payments", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "registration_id"
    t.integer  "op_number"
    t.string   "mr_no"
    t.string   "book_date"
    t.string   "patient_name"
    t.string   "age"
    t.string   "gender"
    t.string   "appt_type"
    t.date     "appt_date",                                                                         :null => false
    t.time     "appt_time",                                                                         :null => false
    t.string   "department"
    t.string   "consultant_id"
    t.string   "consultant_name"
    t.float    "consultant_fee"
    t.string   "bill_no11"
    t.string   "concession_authority", :limit => 250
    t.integer  "concession",           :limit => 10,  :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "paid_amount",          :limit => 10,  :precision => 10, :scale => 0, :default => 0, :null => false
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "mr_no"
    t.string   "admn_no"
    t.string   "image_path"
    t.date     "date",         :null => false
    t.string   "patient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bed_managements", :force => true do |t|
    t.string   "user_id"
    t.string   "ward"
    t.string   "room"
    t.string   "bed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bed_masters", :force => true do |t|
    t.integer  "ward_master_id"
    t.integer  "room_master_id"
    t.string   "name"
    t.string   "code"
    t.string   "status"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bed_transfers", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "admn_no"
    t.string   "mr_no"
    t.string   "admn_date"
    t.string   "transfer_date"
    t.string   "transfer_type"
    t.string   "patient_name"
    t.string   "consultant"
    t.string   "from_floor"
    t.string   "from_ward"
    t.string   "from_room"
    t.string   "from_bed"
    t.string   "no_of_days"
    t.string   "amount"
    t.string   "to_floor"
    t.string   "to_ward"
    t.string   "to_room"
    t.string   "to_bed"
    t.string   "charge_per_day"
    t.string   "remarks"
    t.string   "userid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charge_master_children", :force => true do |t|
    t.integer  "charge_master_id"
    t.string   "reg_type"
    t.string   "name"
    t.float    "discount_price"
    t.integer  "discount_persentage"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charge_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "service_group"
    t.string   "service_name"
    t.string   "test_name"
    t.float    "charge"
    t.string   "insurance"
    t.string   "ins_discount_type"
    t.integer  "ins_discount_value"
    t.string   "corporate"
    t.string   "crp_discount_type"
    t.integer  "crp_discount_value"
    t.float    "lab_amount"
    t.float    "hospital_amount"
    t.float    "external_lab_amount"
    t.string   "lab_type"
    t.string   "charge_ph"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "childmasters", :force => true do |t|
    t.integer  "profilemaster_id"
    t.string   "forms"
    t.string   "new"
    t.string   "view"
    t.string   "edit"
    t.string   "remove"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "city_masters", :force => true do |t|
    t.integer  "state_master_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_lists", :force => true do |t|
    t.string   "hospital_name"
    t.string   "branch_code"
    t.string   "branch_name"
    t.integer  "no_of_users"
    t.integer  "port_number"
    t.string   "display_name"
    t.date     "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complaints", :force => true do |t|
    t.string   "name"
    t.date     "pdate"
    t.time     "ptime"
    t.string   "about"
    t.string   "department", :null => false
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultant_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "consultant_type"
    t.string   "consultant_id"
    t.string   "payment_type"
    t.float    "salary"
    t.string   "salary_type"
    t.integer  "percentage"
    t.integer  "consulting_room"
    t.integer  "extension_no"
    t.string   "charge_type"
    t.string   "charge"
    t.float    "general_charge"
    t.float    "night_duty_charge"
    t.float    "emergency_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultant_visit_children", :force => true do |t|
    t.integer  "consultant_visit_id", :null => false
    t.integer  "sno",                 :null => false
    t.string   "department"
    t.string   "cons_name"
    t.string   "date_and_time"
    t.string   "cons_type"
    t.float    "charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultant_visits", :force => true do |t|
    t.integer  "user_id"
    t.string   "admn_no"
    t.string   "mr_no"
    t.string   "department"
    t.string   "consultant"
    t.date     "date_of_visit"
    t.time     "time_of_visit"
    t.float    "charge"
    t.string   "org_code"
    t.string   "org_location"
    t.string   "patient_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_masters", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "department_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "category"
    t.string   "department"
    t.string   "status"
    t.string   "hod"
    t.string   "ph_no_hod"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discharge_summaries", :force => true do |t|
    t.integer  "user_id"
    t.string   "admn_no"
    t.string   "mr_no"
    t.date     "discharge_date"
    t.time     "time"
    t.string   "discharge_consultant"
    t.string   "status"
    t.string   "medicine"
    t.text     "summary"
    t.date     "review_date"
    t.time     "time1"
    t.text     "remarks"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "empid"
    t.string   "name"
    t.string   "category"
    t.string   "department"
    t.string   "designation"
    t.date     "dob"
    t.date     "join_date"
    t.string   "payment_type"
    t.string   "bank_name"
    t.string   "acc_no"
    t.string   "branch_name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zipcode"
    t.string   "phno"
    t.string   "email_id"
    t.time     "from_time"
    t.time     "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_series", :force => true do |t|
    t.integer  "frequency",  :default => 1
    t.string   "period",     :default => "monthly"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "person_id",                          :null => false
    t.string   "title"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "event_series_id"
  end

  add_index "events", ["event_series_id"], :name => "index_events_on_event_series_id"

  create_table "final_bill_cancels", :force => true do |t|
    t.integer  "user_id"
    t.string   "admn_no"
    t.string   "mr_no"
    t.integer  "receipt_no"
    t.float    "final_bill_amount"
    t.float    "final_bill_cancel_amount"
    t.date     "final_bill_cancel_date"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "final_bills", :force => true do |t|
    t.integer  "user_id"
    t.string   "mr_no"
    t.string   "admn_no"
    t.date     "final_bill_date"
    t.float    "gross_amount"
    t.float    "advance"
    t.float    "due"
    t.string   "concession_authority"
    t.integer  "concession"
    t.float    "remaining_amount"
    t.float    "paid_amount"
    t.float    "balance_amount"
    t.integer  "receipt_no"
    t.string   "payment_mode"
    t.string   "bank_name"
    t.string   "acc_no"
    t.string   "cheque_no"
    t.float    "ward_fee"
    t.string   "card_no"
    t.string   "card_type"
    t.date     "expiry_date"
    t.float    "card_amount"
    t.float    "cheque_amount"
    t.string   "org_location"
    t.string   "org_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "due_authority",        :limit => 50
    t.string   "admn_category",        :limit => 20
    t.time     "final_bill_time"
    t.integer  "extra_days"
    t.float    "extra_charge"
    t.float    "nurse_fee"
    t.float    "doctor_fee"
    t.float    "operation_amount"
    t.float    "assistant_amount"
    t.float    "ot_fee"
    t.float    "anaesthesia_amount"
    t.float    "lab_amount",           :limit => 10
    t.float    "miscellaneous_amount"
  end

  create_table "final_charges", :force => true do |t|
    t.integer  "final_bill_id"
    t.string   "charge_type"
    t.datetime "from"
    t.datetime "to"
    t.integer  "days"
    t.float    "charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goodsrecieptnotemasters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "agency_dl_no"
    t.string   "agency_name"
    t.string   "agency_tin_no"
    t.string   "grn_number"
    t.date     "grn_date"
    t.string   "po_number"
    t.date     "po_date"
    t.string   "vendor_code"
    t.string   "invoice_number"
    t.date     "invoice_date"
    t.string   "stack_point_code"
    t.string   "satck_point_name"
    t.string   "item_name"
    t.float    "total_amount"
    t.float    "discount"
    t.float    "discount_amont"
    t.float    "net_invoice_amount"
    t.float    "total_vat"
    t.string   "status"
    t.string   "pur_ret_no"
    t.float    "ret_amt"
    t.float    "note_amt"
    t.float    "goods_amt"
    t.float    "zero_pre",              :limit => 10, :default => 0.0, :null => false
    t.float    "zero_pre_dic",          :limit => 10, :default => 0.0, :null => false
    t.float    "after_zero_dic",        :limit => 10, :default => 0.0, :null => false
    t.float    "fourt_vat"
    t.float    "fourt_value"
    t.float    "fourt_dic_per",         :limit => 10, :default => 0.0, :null => false
    t.float    "after_fourt_dic",       :limit => 10, :default => 0.0, :null => false
    t.float    "five_vat"
    t.float    "five_value"
    t.float    "five_discount_per",     :limit => 10, :default => 0.0, :null => false
    t.float    "after_five_dic",        :limit => 10, :default => 0.0, :null => false
    t.float    "sub_total"
    t.string   "stock_transfer_status",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homes", :force => true do |t|
    t.string   "image_path"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurance_masters", :force => true do |t|
    t.string   "company_name"
    t.integer  "code"
    t.integer  "phone"
    t.integer  "fax"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "email"
    t.string   "person_name"
    t.string   "person_email"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile",       :limit => 20
    t.string   "org_code",     :limit => 25
    t.string   "org_location", :limit => 25
  end

  create_table "insurance_payments", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "ins_no"
    t.string   "admn_no"
    t.string   "mr_no"
    t.date     "admn_date"
    t.date     "dis_date"
    t.date     "dispatch"
    t.date     "cheque_issue_date"
    t.date     "cheque_submit_date"
    t.string   "status"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ip_dues", :force => true do |t|
    t.string   "admn_no"
    t.string   "mr_no"
    t.date     "due_date"
    t.integer  "receipt_no"
    t.float    "gross_amount"
    t.float    "due"
    t.string   "concession_authority"
    t.integer  "concession"
    t.float    "remaining_amount"
    t.string   "payment_mode"
    t.string   "bank_name"
    t.string   "acc_no"
    t.string   "cheque_no"
    t.float    "cheque_amount"
    t.string   "card_no"
    t.string   "card_type"
    t.date     "expiry_date"
    t.float    "card_amount"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "issue_op_children", :force => true do |t|
    t.integer  "issues_to_op_id"
    t.string   "item_name"
    t.string   "item_code"
    t.string   "batch_no"
    t.date     "expiry_date"
    t.integer  "quantity"
    t.float    "sale_rate",       :limit => 10
    t.float    "purchase_rate",   :limit => 10
    t.string   "discount"
    t.integer  "issue_qty"
    t.float    "total",           :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "vat"
    t.float    "s_no"
    t.string   "mfr",             :limit => 50
  end

  create_table "issues_to_ops", :force => true do |t|
    t.string   "mr_no"
    t.string   "dep_code"
    t.string   "dep_name"
    t.string   "hod"
    t.string   "issue_no"
    t.date     "issue_date"
    t.string   "item_name"
    t.string   "discount_authorization"
    t.string   "ref"
    t.string   "due_authorization"
    t.string   "receipt_no"
    t.float    "total_amount"
    t.float    "paid_amt"
    t.string   "due"
    t.string   "due_ref"
    t.string   "discount_percentage"
    t.string   "due_amount"
    t.string   "payment_type"
    t.string   "bank_name"
    t.string   "cheque_number"
    t.string   "card_number"
    t.string   "card_type"
    t.string   "acc_no"
    t.string   "c_expiry_date"
    t.string   "org_code"
    t.string   "org_location"
    t.float    "cheque_amount"
    t.float    "card_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "patient_type",           :limit => 50
    t.string   "admn_no",                :limit => 50
    t.string   "patient_name",           :limit => 50
    t.integer  "age"
    t.string   "dept_type",              :limit => 25
    t.date     "treatment_date"
    t.string   "reg_type",               :limit => 100
    t.float    "fourt_vat"
    t.float    "five_vat"
    t.float    "fourt_value"
    t.float    "five_value"
    t.string   "consultant",             :limit => 100
    t.integer  "user_id"
  end

  create_table "itemmasters", :force => true do |t|
    t.string   "uom_of_units"
    t.integer  "volume"
    t.string   "uom_of_valume"
    t.string   "org_code"
    t.string   "org_location"
    t.string   "drug_type"
    t.string   "product_name"
    t.string   "product_code"
    t.string   "is_medical_item"
    t.string   "units"
    t.string   "drug_formula"
    t.string   "manufacturer"
    t.string   "packing"
    t.string   "vat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_histories", :force => true do |t|
    t.string   "name"
    t.string   "ip_address"
    t.string   "status"
    t.time     "logout_time"
    t.time     "login_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "manufacturer_name"
    t.string   "manufacturer_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medicine_lists", :force => true do |t|
    t.integer  "treatment_plan_id"
    t.integer  "discharge_summary_id"
    t.integer  "s_no"
    t.string   "name"
    t.string   "code"
    t.string   "frequency"
    t.integer  "quantity"
    t.float    "amount"
    t.string   "comments"
    t.string   "root"
    t.string   "options"
    t.string   "status"
    t.integer  "days"
    t.string   "morning"
    t.string   "afternoon"
    t.string   "night"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "miscellaneous_children", :force => true do |t|
    t.integer  "miscellaneous_master_id"
    t.integer  "s_no"
    t.string   "service"
    t.string   "service_code"
    t.string   "reason"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miscellaneous_masters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "mis_no"
    t.string   "voucher_no"
    t.date     "date"
    t.time     "time"
    t.string   "department"
    t.string   "employee"
    t.float    "total_amount"
    t.string   "authorized_by"
    t.text     "reason"
    t.string   "service"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module_list_children", :force => true do |t|
    t.string   "form_name"
    t.string   "field_type"
    t.string   "path"
    t.integer  "modules_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modules_lists", :force => true do |t|
    t.string   "module_name"
    t.integer  "position"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notice_boards", :force => true do |t|
    t.date     "notice_date"
    t.time     "notice_time"
    t.string   "department"
    t.string   "employee",    :null => false
    t.text     "notice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "number_masters", :force => true do |t|
    t.string   "mr_no"
    t.integer  "mr_no_length",                           :null => false
    t.string   "include_year",             :limit => 30, :null => false
    t.string   "reg_no"
    t.integer  "reg_no_length",                          :null => false
    t.string   "ins_no"
    t.integer  "ins_no_length",                          :null => false
    t.string   "cas_no"
    t.integer  "cas_no_length",                          :null => false
    t.string   "appt_payment_receipt_no"
    t.string   "op_no"
    t.string   "ip_no"
    t.integer  "ip_no_length",                           :null => false
    t.string   "lab_no"
    t.string   "lab_bill_no"
    t.string   "ip_advance_receipt_no"
    t.string   "ip_final_bill_receipt_no"
    t.string   "ins_final_bill_no"
    t.string   "mis_voucher_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "numbers", :force => true do |t|
    t.string   "org_location"
    t.string   "org_code"
    t.string   "name"
    t.integer  "value",        :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "op_patient_returns", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "issue_No"
    t.string   "dep_code"
    t.string   "dep_name"
    t.string   "hod"
    t.string   "receipt_no"
    t.string   "mr_No"
    t.string   "return_no"
    t.date     "return_date"
    t.string   "return_amount"
    t.string   "item_name"
    t.string   "payment_mode"
    t.string   "bank_name"
    t.string   "cheque_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "acc_no",        :limit => 100
    t.string   "patient_name",  :limit => 100
    t.float    "cheque_amount"
    t.string   "patient_type",  :limit => 50
    t.string   "dept_type",     :limit => 50
    t.string   "admn_no",       :limit => 50
    t.integer  "user_id"
  end

  create_table "opreturn_children", :force => true do |t|
    t.integer  "op_patient_return_id"
    t.string   "item_code"
    t.string   "item_name"
    t.string   "batch_no"
    t.date     "expiry_date"
    t.integer  "issue_qty"
    t.float    "sale_rate"
    t.float    "discount"
    t.float    "sale_amount"
    t.integer  "return_qty"
    t.float    "return_rate"
    t.float    "return_amt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "s_no"
    t.string   "mfr",                  :limit => 25
    t.float    "vat"
    t.integer  "user_id"
  end

  create_table "org_master_child_tables", :force => true do |t|
    t.integer  "org_master_id"
    t.string   "branch_code"
    t.string   "branch_name"
    t.string   "branch_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "org_masters", :force => true do |t|
    t.string   "hospital_name"
    t.integer  "no_of_branches"
    t.integer  "port_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_master_majestic_children", :force => true do |t|
    t.integer  "package_master_majestic_id"
    t.string   "ward_name"
    t.float    "charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_master_majestics", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "category"
    t.string   "sub_category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days"
  end

  create_table "pakage_transfers", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "today_date"
    t.time     "present_time"
    t.string   "admn_no"
    t.string   "mr_no"
    t.string   "e_cat"
    t.string   "e_subcat"
    t.string   "days"
    t.float    "amount"
    t.string   "trans_cat"
    t.string   "trans_subcat"
    t.string   "t_days"
    t.string   "t_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "salt"
    t.string   "encrypted_password"
    t.string   "display_name",       :null => false
    t.string   "client_name",        :null => false
    t.string   "profile",            :null => false
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pharmacy_payment_children", :force => true do |t|
    t.integer  "pharmacy_payment_id"
    t.date     "invoice_date"
    t.string   "invoice_no"
    t.string   "po_no"
    t.float    "amount"
    t.string   "check_option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pharmacy_payments", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "payment_no"
    t.date     "payment_date"
    t.date     "payment_due_date"
    t.string   "agency_name"
    t.float    "invoice_total"
    t.float    "alread_paid_amount"
    t.float    "paid_amount"
    t.float    "balance_amount"
    t.string   "status"
    t.text     "notes"
    t.date     "invoice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency_code",        :limit => 100
    t.integer  "user_id"
  end

  create_table "profilemasters", :force => true do |t|
    t.string   "profile_name"
    t.string   "user_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_order_return_children", :force => true do |t|
    t.integer  "purchase_order_return_id"
    t.integer  "s_no"
    t.string   "item_name"
    t.string   "item_code"
    t.string   "batch_no"
    t.date     "expiry_date"
    t.integer  "quantity"
    t.float    "purchase_rate"
    t.integer  "return_qty"
    t.float    "return_rate"
    t.float    "return_amt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_order_returns", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "return_no"
    t.date     "return_date"
    t.string   "purchase_order_no"
    t.string   "purchase_order_date"
    t.string   "vendor"
    t.string   "authorization"
    t.string   "authorized"
    t.string   "a_dep"
    t.string   "item_name"
    t.string   "item_code"
    t.string   "batch_no"
    t.string   "expiry_date"
    t.string   "received_qty"
    t.string   "purchase_rate"
    t.string   "purchase_amt"
    t.string   "return_qty"
    t.string   "return_rate"
    t.string   "amount"
    t.text     "reason_for_return"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency_names",        :limit => 100
    t.string   "expiry_lists",        :limit => 100
    t.string   "expiry_list",         :limit => 100
  end

  create_table "refferal_masters", :force => true do |t|
    t.string   "refferal_name"
    t.string   "email"
    t.string   "ph_no"
    t.string   "org_code"
    t.string   "org_loaction"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "mr_no"
    t.string   "reg_no"
    t.string   "reg_date"
    t.string   "patient_name"
    t.integer  "age"
    t.string   "age_in"
    t.string   "gender"
    t.string   "martial_status"
    t.string   "father_name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "address"
    t.string   "mobile_no"
    t.string   "ph_no"
    t.string   "reg_type"
    t.string   "referral"
    t.string   "referral_name"
    t.string   "referral_contact_no"
    t.string   "name"
    t.string   "ph_no1"
    t.string   "ins_company_name"
    t.string   "policy_no"
    t.string   "relation_to_insurence"
    t.string   "plan_name"
    t.string   "arogyasree_card_no"
    t.string   "userid"
    t.string   "filename"
    t.string   "content_type"
    t.binary   "binary_data"
    t.string   "upload",                :null => false
    t.string   "image_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_masters", :force => true do |t|
    t.integer  "ward_master_id"
    t.string   "name"
    t.string   "code"
    t.string   "floor"
    t.integer  "no_of_beds"
    t.integer  "extension_no"
    t.string   "status"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicemasters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "service_group_code"
    t.string   "service_name"
    t.string   "service_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.integer  "person_id"
    t.string   "ip_address"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "state_masters", :force => true do |t|
    t.integer  "country_master_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_children", :force => true do |t|
    t.string   "goodsrecieptnotemaster_id"
    t.string   "drug_type"
    t.string   "item_name"
    t.string   "batch_no"
    t.float    "sheets"
    t.date     "expiry_date"
    t.string   "quantity"
    t.integer  "received_quantity"
    t.integer  "issued_quantity"
    t.integer  "purchase_return_quantity"
    t.string   "purchase_rate"
    t.string   "purchase_amt"
    t.string   "discount"
    t.string   "total_amt"
    t.string   "units"
    t.float    "amount"
    t.float    "mrp"
    t.float    "free"
    t.string   "sale_rate"
    t.float    "packing"
    t.float    "purchase_discount"
    t.string   "org_code"
    t.string   "requisation_qty",           :limit => 10
    t.float    "vat"
    t.string   "mfr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_radiology_tests", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "patient_name",    :null => false
    t.string   "mr_no"
    t.string   "admn_no"
    t.date     "collection_date"
    t.time     "collection_time"
    t.string   "lab_no"
    t.string   "test_name",       :null => false
    t.text     "impression"
    t.text     "findings"
    t.string   "image_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_test_result_children", :force => true do |t|
    t.integer  "store_test_result_id"
    t.string   "servce_name"
    t.string   "test_name"
    t.float    "rate"
    t.string   "lbound",               :limit => 100
    t.float    "ubound"
    t.string   "units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "result",               :limit => 20
    t.string   "field_type",           :limit => 50
  end

  create_table "store_test_results", :force => true do |t|
    t.integer  "test_booking_id",               :null => false
    t.string   "mr_no"
    t.string   "admn_no"
    t.string   "patient_type"
    t.string   "service_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lab_no",          :limit => 20
    t.string   "org_code",        :limit => 20
    t.string   "org_location",    :limit => 20
    t.string   "field_type",      :limit => 50
  end

  create_table "test_booking_children", :force => true do |t|
    t.integer "test_booking_id"
    t.string  "investigation",   :null => false
    t.string  "test_name"
    t.float   "rate"
    t.string  "dis_ptage"
    t.float   "dis_amount"
    t.float   "amount"
    t.string  "department"
    t.string  "status"
    t.string  "lab_type"
    t.float   "lab_amount"
    t.string  "org_code"
    t.date    "created_at"
    t.date    "updated_at"
  end

  create_table "test_bookings", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "patient_type"
    t.string   "mr_no"
    t.string   "admn_no"
    t.string   "patient_name"
    t.string   "refferal_doctor"
    t.date     "booking_date",                                                                     :null => false
    t.string   "lab_services"
    t.string   "lab_no"
    t.integer  "bill_no"
    t.float    "total_amount"
    t.string   "concession_authority"
    t.float    "concession"
    t.float    "grand_total"
    t.integer  "paid_amount",          :limit => 10, :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "due",                  :limit => 10, :precision => 10, :scale => 0, :default => 0, :null => false
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_cancels", :force => true do |t|
    t.string "lab_id"
    t.string "department_name"
    t.string "service_name"
    t.text   "reason"
    t.string "org_code"
    t.string "org_location"
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "testmaster_children", :force => true do |t|
    t.integer  "testmaster_id"
    t.string   "paramaters"
    t.string   "field_type"
    t.string   "normal_range"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testmasters", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "investigation",   :null => false
    t.string   "department_name"
    t.string   "test_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "treatment_plans", :force => true do |t|
    t.string   "org_code"
    t.string   "org_location"
    t.string   "registration_id"
    t.string   "patient_type"
    t.string   "mr_no"
    t.string   "admn_no"
    t.date     "treatment_date"
    t.time     "treatment_time"
    t.string   "consultant_id"
    t.string   "medicines"
    t.string   "op_no"
    t.string   "advice"
    t.string   "next_visit"
    t.string   "user_id"
    t.integer  "weight"
    t.integer  "pulse"
    t.date     "created_at"
    t.datetime "updated_at"
    t.integer  "temparature"
    t.integer  "bp_systolic"
    t.integer  "bp_diastolic"
  end

  create_table "ward_costs", :force => true do |t|
    t.string   "consultant_master_id"
    t.string   "ward"
    t.string   "gcost"
    t.string   "night_duty_cost"
    t.string   "emergency_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ward_masters", :force => true do |t|
    t.string   "name"
    t.string   "no_of_rooms"
    t.float    "cost"
    t.string   "org_code"
    t.string   "org_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
