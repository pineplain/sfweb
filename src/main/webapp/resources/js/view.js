var showSfProps = function(prop) {
	$('#task_id').text(prop.id);
	$('#task_name').text(prop.taskName);
	$('#workload').text(prop.workload);
	$('#worker').text(prop.worker);
	$('#location').text(prop.location);
	$('#comment').text(prop.comment);
};
