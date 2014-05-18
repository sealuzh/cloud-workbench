module MetricDefinitionsHelper
  def confirm_delete_metric_msg(metric)
    { confirm: "This action deletes the <strong>#{metric.name}</strong> metric definition and all its associated observations.".html_safe }
  end
end
