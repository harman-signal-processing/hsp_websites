jQuery ->
  $('#s3_uploader').S3Uploader
    remove_completed_progress_bar: false
    progress_bar_target: $('#uploads_container')

  $('#s3_uploader').bind 's3_upload_failed', (e, content) ->
    alert("#{ content.filename } failed to upload : #{ content.error_thrown }")


