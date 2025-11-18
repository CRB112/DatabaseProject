document.addEventListener("DOMContentLoaded", function() {
    const scrollableElement = document.getElementById('scrollableElement');
    const scrollSpeed = 1;
    const scrollDelay = 20;
    const pauseDuration = 500;
    let direction = 1;
    let isPaused = false;

    function autoScroll() {
        if (isPaused) return;

        scrollableElement.scrollLeft += scrollSpeed * direction;

        if (scrollableElement.scrollLeft + scrollableElement.clientWidth >= scrollableElement.scrollWidth) {
            isPaused = true;
            setTimeout(() => {
                direction = -1;
                isPaused = false;
            }, pauseDuration);
        }

        if (scrollableElement.scrollLeft <= 0) {
            isPaused = true;
            setTimeout(() => {
                direction = 1;
                isPaused = false;
            }, pauseDuration);
        }
    }

    setInterval(autoScroll, scrollDelay);
});
