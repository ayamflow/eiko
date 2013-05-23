'use strict';

/*
*   Scroll Tween Directive
*   Enables any div to start a timeline only when it appears on the screen
*   Usage : <div scroll-tween="timelineName"></div>
*   Note that "timelineName" should be a timelineMax object from the scope.
*/

angular.module('myApp.directives')
.directive('scrollTween', [ '$timeout', '$route', function($timeout, $route) {
    return {
        link: function(scope, elem, attr) {

            var elemScrollPos, timeline;

            scope.$on("$page.ready", init);
            scope.$on("$destroy", destroy);

            function init() {
                $(window).scroll(onMouseScroll);
                elemScrollPos = elem.offset().top;
                timeline = scope[attr.scrollTween];
                timeline.call(destroy);
                onMouseScroll();
            }

            function onMouseScroll() {
                var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop) + window.innerHeight;
                var maxScroll = Math.max(document.body.scrollHeight | 0, document.documentElement.scrollHeight | 0);

                // How much screen are we waiting before starting the timeline
                var visibilityArea = window.innerHeight - 200;

                if(currentScroll >= elemScrollPos + visibilityArea || currentScroll == maxScroll) {
                    timeline.play();
                }
            }

            function destroy(e) {
                timeline.kill();
                $(window).off('scroll', onMouseScroll);
            }
        }
    };
}]);