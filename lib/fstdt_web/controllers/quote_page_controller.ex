defmodule FstdtWeb.QuotePageController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :anon

  def show(conn, %{"quote" => q}) do
    body_markdown = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur eget consequat nibh. Fusce massa leo, pretium ac diam at, condimentum facilisis magna. Aliquam turpis erat, vehicula sed elit ac, imperdiet faucibus tellus. Praesent tempor tellus ligula, non euismod mi venenatis sed. Suspendisse non risus eget purus euismod lobortis vitae id diam. Nam magna massa, efficitur ac ligula nec, molestie fermentum orci. Nulla facilisi. Sed gravida mollis tortor, eget pulvinar nisl aliquet id. Suspendisse vitae augue in augue sodales rutrum ut ut dolor. Cras facilisis pharetra leo, et dictum mi scelerisque vitae. Nullam dapibus urna at purus maximus, quis ultrices metus cursus.

    Morbi diam elit, convallis ac volutpat eget, tempus a nisl. Nullam efficitur rhoncus augue, sit amet consequat lacus blandit in. Aliquam eget eros arcu. Proin vel iaculis nulla, sodales mollis ipsum. Pellentesque egestas nisi fringilla, tempor nunc et, hendrerit orci. Morbi elementum diam quis lacinia hendrerit. Etiam dapibus imperdiet ante sit amet luctus. Nullam vitae elit vel nulla porta ultricies. Nulla auctor risus sapien, vel aliquam purus congue et. Sed tristique volutpat iaculis. Vestibulum vel orci sollicitudin, convallis nisi blandit, dignissim libero. Integer accumsan tortor sed accumsan luctus. Phasellus a sapien porttitor erat laoreet lobortis. Fusce lacinia tempor porta.

    Nulla non ante efficitur, sodales sapien quis, tristique tortor. Aenean tempor sollicitudin accumsan. Duis posuere, lectus quis faucibus fringilla, lorem diam iaculis sapien, non elementum magna nunc id odio. Duis sed augue eget augue maximus dapibus nec malesuada tellus. Nulla viverra at dui ut fringilla. Praesent consectetur vulputate augue. Praesent convallis commodo massa vitae gravida. Ut mollis et eros ut pulvinar. Integer ac arcu imperdiet, finibus lectus nec, consequat enim. Donec eu mauris quis ante posuere finibus. Vivamus vehicula varius interdum. Etiam nibh elit, pellentesque ut aliquam vel, placerat eget nulla. Nulla ac leo enim. Vivamus erat eros, luctus et elit sed, imperdiet rhoncus magna. Suspendisse potenti.

    Cras non malesuada magna. Quisque ut iaculis lorem. Suspendisse eu elementum dolor. Aenean semper malesuada dapibus. Praesent orci felis, accumsan eu iaculis at, porta vel enim. Donec vitae diam ut massa tempor maximus auctor at neque. Ut pulvinar, tellus nec bibendum ornare, massa leo vehicula odio, id imperdiet ex arcu in orci. Phasellus in vestibulum ipsum. Duis ac felis vitae leo ornare luctus sit amet a turpis. Aliquam facilisis libero a est maximus maximus vitae sed dolor. Duis sit amet finibus urna, quis dapibus nulla. Nam eu maximus purus. Donec dapibus eu sapien a interdum.

    In hac habitasse platea dictumst. Curabitur in risus dignissim, convallis tortor in, facilisis nisi. Nulla facilisi. Ut mi justo, tristique eget felis id, scelerisque convallis risus. Nunc egestas lorem id justo tempor tristique. Vivamus lacinia, diam quis semper porttitor, dolor magna ullamcorper felis, nec egestas nisi urna congue magna. Aenean tempor varius ultricies. Duis convallis, odio interdum volutpat varius, felis urna egestas quam, pretium hendrerit nunc ex ut mi. 
    """
    canonical_url = quote_page_url(conn, :show, q)
    {:ok, body_html} = Rundown.convert(canonical_url, body_markdown)
    render conn, "show.html",
      quote: %{
        id: q,
        url: "http://lipsum.com/",
        body_html: body_html,
        author: %{name: "Automated System"},
        board: %{name: "Lorem Ipsum Generator"},
        submitter: %{name: "pyro"},
        comment_count: 3,
        fundie_index: 2},
      comment_nonce: Integer.to_string(:rand.uniform(4294967296), 32) <> Integer.to_string(:rand.uniform(4294967296), 32)
  end
end
