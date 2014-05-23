# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140523213549) do

  create_table "benchmark_definitions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "vagrantfile"
  end

  add_index "benchmark_definitions", ["name"], name: "index_benchmark_definitions_on_name", unique: true

  create_table "benchmark_executions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_definition_id"
  end

  add_index "benchmark_executions", ["benchmark_definition_id"], name: "index_benchmark_executions_on_benchmark_definition_id"

  create_table "benchmark_schedules", force: true do |t|
    t.string   "cron_expression"
    t.boolean  "active",                  default: true
    t.integer  "benchmark_definition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "benchmark_schedules", ["benchmark_definition_id"], name: "index_benchmark_schedules_on_benchmark_definition_id"

  create_table "cloud_providers", force: true do |t|
    t.string   "name"
    t.string   "credentials_path"
    t.string   "ssh_key_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "events", force: true do |t|
    t.integer  "name"
    t.datetime "happened_at"
    t.integer  "traceable_id"
    t.string   "traceable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "metric_definitions", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_definition_id"
    t.string   "scale_type"
  end

  add_index "metric_definitions", ["name", "benchmark_definition_id"], name: "index_metric_definitions_on_name_and_benchmark_definition_id", unique: true

  create_table "nominal_metric_observations", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time",                        limit: 8
    t.integer  "virtual_machine_instance_id"
    t.integer  "metric_definition_id"
  end

  add_index "nominal_metric_observations", ["metric_definition_id"], name: "index_nominal_metric_observations_on_metric_definition_id"
  add_index "nominal_metric_observations", ["virtual_machine_instance_id"], name: "index_nominal_metric_observations_on_vm_instance_id "

  create_table "ordered_metric_observations", force: true do |t|
    t.integer  "metric_definition_id"
    t.integer  "virtual_machine_instance_id"
    t.integer  "time",                        limit: 8
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ordered_metric_observations", ["metric_definition_id"], name: "index_ordered_metric_observations_on_metric_definition_id"
  add_index "ordered_metric_observations", ["virtual_machine_instance_id"], name: "index_ordered_metric_observations_on_vm_instance_id"

  create_table "virtual_machine_instances", force: true do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_execution_id"
    t.string   "provider_name"
    t.string   "provider_instance_id"
    t.string   "role"
  end

  add_index "virtual_machine_instances", ["benchmark_execution_id"], name: "index_virtual_machine_instances_on_benchmark_execution_id"
  add_index "virtual_machine_instances", ["provider_instance_id", "provider_name"], name: "index_vm_instances_on_provider_instance_id_and_provider_name"

end
