

class SimplePrompt {
  final String header;
  final String body;

  SimplePrompt({
    required this.header,
    required this.body,
  });

  SimplePrompt copyWith({
    String? header,
    String? body,
  }) {
    return SimplePrompt(
      header: header ?? this.header,
      body: body ?? this.body,
    );
  }
}

class HtmlPrompt {
  final String header;
  final String title;
  final String body;
  final SimplePrompt fallback;

  HtmlPrompt({
    required this.header,
    required this.title,
    required this.body,
    required this.fallback,
  });

  HtmlPrompt copyWith({
    String? header,
    String? summary,
    String? body,
    SimplePrompt? fallback,
  }) {
    return HtmlPrompt(
      header: header ?? this.header,
      title: summary ?? this.title,
      body: body ?? this.body,
      fallback: fallback ?? this.fallback,
    );
  }
}