#
# Cookbook Name:: aws-cloudwatch
# Resources:: aws_cloudwatch_log
#

resource_name :aws_cloudwatch_log
provides :aws_cloudwatch_log

property :file_path, String, required: true, name_property: true
property :log_group_name, String, required: true
property :log_stream_name, String, required: true
property :timezone, String, required: false, equal_to: %w(Local UTC)
property :timestamp_format, String, required: false
property :encoding, String, required: false, default: 'utf-8', equal_to: %w(utf-8 ascii big5 euc-jp euc-kr gbk gb18030 ibm866 iso2022-jp iso8859-2 iso8859-3 iso8859-4 iso8859-5 iso8859-6 iso8859-7 iso8859-8 iso8859-8-i iso8859-10 iso8859-13 iso8859-14 iso8859-15 iso8859-16 koi8-r koi8-u macintosh shift_jis utf-8 utf-16 windows-874 windows-1250 windows-1251 windows-1252 windows-1253 windows-1254 windows-1255 windows-1256 windows-1257 windows-1258 x-mac-cyrillic)

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  Chef::Log.info "Adding configuration for #{cookbook_name}"
  with_run_context :root do
    edit_resource(:template, node['aws_cloudwatch']['config_file']) do |new_resource|
      self.cookbook_name = 'aws-cloudwatch'
      source 'awslogs.conf.erb'
      variables[:logs] ||= []
      log_params = {
        file_path: new_resource.file_path,
        log_group_name: new_resource.log_group_name,
        log_stream_name: new_resource.log_stream_name,
        encoding: new_resource.encoding
      }
      log_params.merge(timezone: new_resource.timezone) if new_resource.timezone
      log_params.merge(timestamp_format: new_resource.timestamp_format) if new_resource.timestamp_format
      variables[:logs].push(log_params)

      action :nothing
      delayed_action :create
      notifies :restart, 'service[amazon-cloudwatch-agent]', :delayed
    end
  end
end
