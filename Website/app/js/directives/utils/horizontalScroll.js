'use strict';

angular.module('myApp.directives')
.directive('horizontalScroll', [ '$timeout', '$route', function($timeout, $route) {
    return {
        link: function(scope, element, attr) {

            var $inner, $outer, baseWidth, baseHeight, number, $slides, position = 0, maxScroll, $thumbs, currentSlide = 0, slideOffset, canScroll = true;

            $timeout(init);

            scope.$on("$destroy", destroy);
            $(window).bind('resize', resize);

            function init() {
                $outer = element.find('.' + attr['outer']);
                $inner = element.find('.' + attr['inner']);
                $slides = element.find('.' + attr['slide']);

                number = $slides.length;

                resize();
                if(attr['nav'] == "true") createNav();

                // element.on('mousewheel', onMouseScroll);
                // $(window).on('mousewheel DOMMouseScroll', onMouseScroll);
                // $(window).on('scroll', onMouseScroll);
            }

            function resize() {
                baseWidth = window.innerWidth;// $slides.eq(0).width();
                baseHeight = window.innerHeight;
                $slides.css('width', baseWidth);
                maxScroll = baseWidth * number;
                $inner.width(maxScroll);
                slideOffset = baseWidth * 0.4;
            }

            function createNav() {
                $thumbs = element.prepend('<ul class="thumbs"></ul>').find('.thumbs');
                for(var i=0; i < number; i++) {
                    $thumbs.append($('<li/>'));
                }

                element.find('.thumbs li').on('click', changeSlide).eq(0).addClass('current');
            }

            function changeSlide(e) {
                element.find('.thumbs li').removeClass('current');
                var $target = $(e.currentTarget).addClass('current');
                var index = $target.index();
                // console.log('changeSlide', index);
                if(index === currentSlide) return;
                TweenMax.killChildTweensOf($thumbs);
                TweenMax.to(element, 0.8, {alpha: 1, scrollLeft: index * baseWidth, ease: Power2.easeInOut});

                var slideAnimation = {delay: 0.1, ease: Power2.easeInOut};
                if(currentSlide < index) {
                    slideAnimation.left = slideOffset;
                }
                else {
                    slideAnimation.right = slideOffset;
                }

                TweenMax.from($slides.eq(index).find('.content'), 1, slideAnimation);
                // element.scrollLeft(targetIndex * baseWidth);
                currentSlide = index;
            }

            function onMouseScroll(e) {
                $timeout(function() {
                    var scrollTop = $(window).scrollTop();

                    console.log(scrollTop, baseHeight);

                    if(canScroll && scrollTop >= baseHeight && scrollTop < baseHeight * 2) {
                        var scrollLeft = element.scrollLeft();

                        var direction = -e.originalEvent.wheelDelta / Math.abs(e.originalEvent.wheelDelta);

                        if(direction > 0) {
                            if(scrollLeft >= baseWidth  && scrollLeft <= baseWidth * number) {
                                scrollSlide(e, direction, scrollLeft);
                            }
                            else {
                                cancelScroll();
                            }
                        }
                        else if(direction < 0) {
                            if(scrollLeft >= baseWidth && scrollLeft <= baseWidth * number) {
                                scrollSlide(e, direction, scrollLeft);
                            }
                            else {
                                cancelScroll();
                            }
                        }
                    }
                }, 300);

                       /* if(direction > 0 && scrollLeft < baseWidth * (number - 1) || direction < 0 && scrollLeft > baseWidth) {
                        }
                        else {
                            // $(window).off('mousewheel DOMMouseScroll', onMouseScroll);
                            $timeout(function() {
                                scope.canScroll = true;
                            }, 250);
                        }*/
                        // position = Math.max(0, Math.min(maxScroll - baseWidth, position - e.originalEvent.wheelDelta));
                        // element.scrollLeft(position);
                        // element.scrollLeft(scrollLeft + (-e.originalEvent.wheelDelta/120) * baseWidth);
            }

            function scrollSlide(e, direction, scrollLeft) {
                scope.canScroll = false;
                canScroll = false;
                e.preventDefault();
                TweenMax.to(element, 0.2, {scrollTo:{x: scrollLeft + direction * baseWidth, y: 0}, onComplete: enableScroll});
            }

            function cancelScroll() {
                $timeout(function() {
                    scope.canScroll = true;
                }, 250);
            }

            function enableScroll() {
                $thumbs.find('li').removeClass('current');
                var currentIndex = ~~(element.scrollLeft() / baseWidth);
               $thumbs.find('li').eq(currentIndex).addClass('current');
                canScroll = true;
            }

            function destroy(e) {
                $(window).off('mousewheel DOMMouseScroll', onMouseScroll);
                element.find('.thumbs li').off('click', changeSlide).eq(0).addClass('current');
            }
        }
    };
}]);