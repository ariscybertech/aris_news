import 'package:aris_news/aris/blocs/newsbloc/news_events.dart';
import 'package:aris_news/aris/blocs/newsbloc/news_states.dart';
import 'package:aris_news/aris/models/article_model.dart';
import 'package:aris_news/aris/repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvents, NewsStates> {
  NewsRepository newsRepositoty;
  NewsBloc({@required NewsStates initialState, @required this.newsRepositoty})
      : super(initialState) {
    on<StartEvent>((event, emit) {
      add(StartEvent());
    });
  }

  @override
  Stream<NewsStates> mapEventToState(NewsEvents event) async* {
    if (event is StartEvent) {
      try {
        List<ArticleModel> _articleList = [];
        yield NewsLoadingState();
        _articleList = await newsRepositoty.fetchNews();
        yield NewsLoadedState(articleList: _articleList);
      } catch (e) {
        yield NewsErrorState(errorMessage: e);
      }
    }
  }
}
