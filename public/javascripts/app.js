$(document).ready(function() {
    //handle votes

    $('.vote-links').on('click', '.vote', function(e) {
      e.preventDefault();
      var ids = $('.vote-links').data();
      var vote_data = $(this).data('vote');
      $.ajax({
        url: '/vote/' + ids.voteId,
        method: "POST",
        data: {
          vote_type: vote_data,
          question_id: ids.questionId
        }
      }).done(function() {
        console.log('voted')
      });


      var $votes = $(this).parent().siblings('.vote_count')
      var voteTotal = parseInt($votes.html());
      vote_data === "positive" ? $votes.html(voteTotal + 1) : $votes.html(voteTotal - 1);

    });
});
