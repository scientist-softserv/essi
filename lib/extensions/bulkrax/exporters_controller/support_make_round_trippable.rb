module Extensions
  module Bulkrax
    module ExportersController
      module SupportMakeRoundTrippable
        # modified to support :make_round_trippable
        def exporter_params
          params[:exporter][:export_source] = params[:exporter]["export_source_#{params[:exporter][:export_from]}".to_sym]
          if params[:exporter][:date_filter] == "1"
            params.fetch(:exporter).permit(:name, :user_id, :export_source, :export_from, :export_type,
                                           :parser_klass, :limit, :start_date, :finish_date, :work_visibility,
                                           :make_round_trippable,
                                           :workflow_status, field_mapping: {})
          else
            params.fetch(:exporter).permit(:name, :user_id, :export_source, :export_from, :export_type,
                                           :parser_klass, :limit, :work_visibility, :workflow_status,
                                           :make_round_trippable,
                                           field_mapping: {}).merge(start_date: nil, finish_date: nil)
          end
        end
      end
    end
  end
end
