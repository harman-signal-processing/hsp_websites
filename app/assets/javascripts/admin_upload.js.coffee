jQuery ->
  $('#s3_uploader').S3Uploader
    remove_completed_progress_bar: false
    progress_bar_target: $('#uploads_container')

  $('#s3_uploader').bind 's3_upload_failed', (e, content) ->
    alert("#{ content.filename } failed to upload : #{ content.error_thrown }")


#  $('#new_software').fileupload
#    dataType: "script"
#    add: (e, data) ->
#      data.context = $(tmpl("software-upload", data.files[0]).trim()) if $('#software-upload').length > 0
#      $('#software_progress').html(data.context)
#      data.submit()
#    progress: (e, data) ->
#      if data.context
#        progress = parseInt(data.loaded / data.total * 100, 10)
#        data.context.find('.meter').css('width', progress + '%')
