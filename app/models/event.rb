class Event < ActiveRecord::Base
  belongs_to :traceable, polymorphic: true
  validates :name, presence: true
  validates :happened_at, presence: true

  # Success range: 0..100
  # Failed range: 101..200
  enum name: {
               created:                             0,
               started_preparing:                  10,
                 failed_on_preparing:             111,
               finished_preparing:                 20,
               started_running:                    30,
                 failed_on_start_running:         130,
                 failed_on_running:               131,
               finished_running:                   40,
               started_postprocessing:             50,
                 failed_on_start_postprocessing:  150,
                 failed_on_postprocessing:        151,
               finished_postprocessing:            60,
               started_releasing_resources:        70,
                 failed_on_releasing_resources:   171,
               finished_releasing_resources:       80,
             }

  STATUS_MAPPINGS = {
                      created:                          'WAITING FOR START PREPARING',
                      started_preparing:                'PREPARING',
                        failed_on_preparing:            'FAILED ON PREPARING',
                      finished_preparing:               'WAITING FOR START RUNNING',
                      started_running:                  'RUNNING',
                        failed_on_start_running:        'FAILED ON START RUNNING',
                        failed_on_running:              'FAILED ON RUNNING',
                      finished_running:                 'WAITING FOR START POSTPROCESSING',
                      started_postprocessing:           'POSTPROCESSING',
                        failed_on_start_postprocessing: 'FAILED ON START POSTPROCESSING',
                        failed_on_postprocessing:       'FAILED ON POSTPROCESSING',
                      finished_postprocessing:          'WAITING FOR START RELEASING RESOURCES',
                      started_releasing_resources:      'RELEASING RESOURCES',
                        failed_on_releasing_resources:  'FAILED ON RELEASING RESOURCES',
                      finished_releasing_resources:     'FINISHED',
                    }

  def failed?
    in_failed_range?(Event.names[self.name])
  end

  def status
    STATUS_MAPPINGS[self.name.to_sym]
  end

  private

    def in_failed_range?(value)
      (101..200).include?(value)
    end
end