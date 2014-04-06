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

ActiveRecord::Schema.define(version: 20140406140215) do

  create_table "benchmark_definitions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "benchmark_definitions", ["name"], name: "index_benchmark_definitions_on_name", unique: true

  create_table "benchmark_executions", force: true do |t|
    t.string   "status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_definition_id"
  end

  add_index "benchmark_executions", ["benchmark_definition_id"], name: "index_benchmark_executions_on_benchmark_definition_id"

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

  create_table "metric_definitions", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_definition_id"
  end

  create_table "metric_observations", force: true do |t|
    t.integer  "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "metric_definition_id"
    t.integer  "benchmark_execution_id"
  end

  add_index "metric_observations", ["benchmark_execution_id"], name: "index_metric_observations_on_benchmark_execution_id"
  add_index "metric_observations", ["metric_definition_id"], name: "index_metric_observations_on_metric_definition_id"

  create_table "virtual_machine_definitions", force: true do |t|
    t.string   "role"
    t.string   "region"
    t.string   "instance_type"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_definition_id"
    t.integer  "cloud_provider_id"
  end

  add_index "virtual_machine_definitions", ["benchmark_definition_id"], name: "index_virtual_machine_definitions_on_benchmark_definition_id"
  add_index "virtual_machine_definitions", ["cloud_provider_id"], name: "index_virtual_machine_definitions_on_cloud_provider_id"

  create_table "virtual_machine_instances", force: true do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "virtual_machine_definition_id"
    t.integer  "benchmark_execution_id"
  end

  add_index "virtual_machine_instances", ["benchmark_execution_id"], name: "index_virtual_machine_instances_on_benchmark_execution_id"
  add_index "virtual_machine_instances", ["virtual_machine_definition_id"], name: "index_vm_instances_on_vm_definition_id"

end
