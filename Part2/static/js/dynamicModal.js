document.querySelectorAll('[data-student-id]').forEach(function(button) {
    button.addEventListener('click', function() {
        // Get the student ID from the data-student-id attribute
        var studentID = this.getAttribute('data-student-id');
        var courseID = this.getAttribute('data-course-id');
        var secID = this.getAttribute('data-sec-id');

        // Set the student ID to the hidden input field inside the modal
        var studentIDField = document.getElementById('studentID');
        var courseIDField = document.getElementById('courseID');
        var secIDField = document.getElementById('secID');
        if (studentIDField) {
            studentIDField.value = studentID;
        }
        if (courseIDField) {
            courseIDField.value = courseID;
        }
        if (secIDField) {
            secIDField.value = secID;
        }
    });
});