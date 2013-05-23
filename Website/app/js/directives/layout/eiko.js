'use strict';

angular.module('myApp.directives')
.directive('eiko', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {

            /*------------------------
                    Variables
            ------------------------*/
            var baseHeight, screenNumber, $header, $dots, isReady = false, currentScreen = 0;
            scope.canScroll = true;

            $timeout(init);

            function init() {
                $(window).on('resize', resize);
                // $(window).on('mousewheel', onMouseWheel);
                $(window).on('scroll', onScroll);
                $(window).on('mousewheel DOMMouseScroll', onMouseWheel);

                $header = $('header');
                $dots = $header.find('.dot');
                $header.find('li a').on('click', goToPage);

                resize();
                $timeout(onScroll);
            }

            /*------------------------
                    Resize
            ------------------------*/
            function resize() {
                $timeout(onResize);
            }

            function onResize() {
                baseHeight = window.innerHeight;
                screenNumber = $('.screen').length;
                if(!isReady) {
                    // $(window).scrollTop(0);
                    scope.$broadcast("$page.ready");
                    isReady = true;
                }
                else {
                    $(window).scrollTop(currentScreen * baseHeight);
                }
            }

            /*------------------------
                    Scroll handlers
            ------------------------*/
            function onScroll(e) {
                var scrollTop = $(window).scrollTop();

                updateMenu(scrollTop);
                updateHeader(scrollTop);
            }

            /*------------------------
                Smooth scrolling
            ------------------------*/
            function onMouseWheel(e) {
                e.preventDefault();
                if(scope.canScroll) {
                    scope.canScroll = false;
                    currentScreen = Math.max(0, Math.min(screenNumber, currentScreen - e.originalEvent.wheelDelta / 120));
                    TweenMax.to(window, 0.2, {scrollTo:{x:0, y: currentScreen * baseHeight}, onComplete: enableScroll});
                }
            }

            function enableScroll() {
                scope.canScroll = true;
            }

            /*------------------------
                Menu links handlers
            ------------------------*/
            function goToPage(e) {
                e.preventDefault();
                var position = $(e.currentTarget).parent().index();
                TweenMax.to(window, 0.7, {scrollTo:{x: 0, y:position * baseHeight}, ease: Cubic.easeInOut});
            }

            /*------------------------
                    Menu bullet
            ------------------------*/
            function updateMenu(scrollTop) {
                currentScreen = ~~($(window).scrollTop() / baseHeight * 1.3);
                $dots.removeClass('selected').eq(currentScreen).addClass('selected');
            }

            /*------------------------
                    Header change
            ------------------------*/
            function updateHeader(scrollTop) {
                // Scroll past first screen: show light header
                if(scrollTop > baseHeight * 0.7) {
                    showLightHeader();
                }
                // Scroll before first screen: show big header
                else {
                    showBigHeader();
                }
            }

            function showBigHeader() {
                $header.removeClass('light').addClass('big');
            }

            function showLightHeader() {
                $header.removeClass('big').addClass('light');
            }

            /*------------------------
                    Destroy
            ------------------------*/
            function destroy(e) {
                $(window).off('resize', resize);
                $(window).off('scroll', onScroll);
                $header.find('li a').off('click', goToPage);
            }
        }
    };
}]);