function start_slideshow(start_frame, end_frame, delay, transition) {
 	slideshow_controller = setTimeout(switch_slides(start_frame,start_frame,end_frame, delay, transition), delay);
	current_frame_controller = setTimeout("", delay);
	next_frame_controller = setTimeout("", delay);
}
                     
function switch_slides(frame, start_frame, end_frame, delay, transition) {
 return (function() {
	if (transition != "toggle") { transition = "fadeOut"; }
	 eval("$('#slideshow_" + frame +"')." + transition + "();");
	 $('#slideshow_control_' + frame).removeClass('current_button');
     if (frame == end_frame) { frame = start_frame; } else { frame = frame + 1; }
     next_frame_controller = setTimeout(switch_slides(frame, start_frame, end_frame, delay, transition), delay + 850);
     if (transition != "toggle") { transition = "fadeIn"; }
     current_frame_controller = setTimeout("$('#slideshow_" + frame + "')." + transition + "();$('#slideshow_control_" + frame +"').addClass('current_button');", 175);
 })
}

function stop_slideshow(stop_on, last_frame) {
	if (slideshow_controller)
		clearTimeout(slideshow_controller);
	if (current_frame_controller)
		clearTimeout(current_frame_controller);
	if (next_frame_controller)
		clearTimeout(next_frame_controller);
	for (var i=1; i<=last_frame; i++) {
		$('#slideshow_' + i).hide();
		$('#slideshow_control_' + i).removeClass('current_button');
	}
	$('#slideshow_' + stop_on).show();
	$('#slideshow_control_' + stop_on).addClass('current_button');
}