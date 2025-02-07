// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dev_tools/development/debugger/curl_generator.dart';
import 'package:dev_tools/development/debugger/stream_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class RequestModel {
  RequestOptions requestOptions;
  Response? response;
  RequestModel({
    required this.requestOptions,
    this.response,
  });
}

ListSync<RequestModel> apiRequests = ListSync<RequestModel>();

class ApiLogger extends StatefulWidget {
  const ApiLogger({super.key});

  static Interceptor use() {
    return ApiLoggerInterceptor();
  }

  @override
  State<ApiLogger> createState() => _ApiLoggerState();
}

class _ApiLoggerState extends State<ApiLogger> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  int detailsTab = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageRouteBuilder(
            pageBuilder: (context, a, v) => buildOverView(),
          );
        }
        if (settings.name == '/details') {
          return PageRouteBuilder(
              pageBuilder: (context, a, b) => FadeTransition(
                  opacity: a,
                  child: buildDetails(settings.arguments as RequestModel)));
        }
      },
    );
  }

  Widget buildDetails(RequestModel requestModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            children: [
              BackButton(),
              Text('Go Back'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      detailsTab = 0;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Request',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: detailsTab == 0
                              ? Colors.blue
                              : Colors.black.withOpacity(0.5),
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      detailsTab = 1;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Response',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: detailsTab == 1
                              ? Colors.blue
                              : Colors.black.withOpacity(0.5),
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () async {
                      String cUrl = generateCurlCommand({
                        'url': requestModel.requestOptions.path,
                        'method': requestModel.requestOptions.method,
                        'headers': requestModel.requestOptions.headers.entries
                            .map(
                              (value) {
                                return '${value.key}: ${value.value}';
                              },
                            )
                            .toList()
                            .join(','),
                        'body': requestModel.requestOptions.method != 'GET'
                            ? requestModel.requestOptions.data
                            : parseQueryParameters(requestModel),
                      },
                          isMultipart: requestModel.requestOptions.listFormat ==
                              ListFormat.multiCompatible);
                      await Clipboard.setData(ClipboardData(text: cUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Copy cURL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          if (detailsTab == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.brown.shade100),
                      child: const Center(child: Text('Request Options'))),
                  if (parseQueryParameters(requestModel) != null) ...{
                    const Text(
                      'Query parameters:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        normalizeMap(parseQueryParameters(requestModel) ?? {})),
                  },
                  if (requestModel.requestOptions.data is Map &&
                      requestModel.requestOptions.data.isNotEmpty) ...{
                    const Text('Data:'),
                    Text(requestModel.requestOptions.data.toString()),
                  },
                  const SizedBox(height: 10),
                  const Text(
                    'Headers:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(normalizeMap(requestModel.requestOptions.headers)),
                ],
              ),
            ),
          if (detailsTab == 1) buildResponse(requestModel)
        ],
      ),
    );
  }

  Widget buildResponse(RequestModel requestModel) {
    if (requestModel.response?.data is Map) {
      return JsonView.map(
        requestModel.response?.data,
        theme: const JsonViewTheme(
            backgroundColor: Colors.transparent,
            keyStyle: TextStyle(
              color: Colors.grey,
            ),
            boolStyle: TextStyle(color: Colors.lightGreenAccent),
            doubleStyle: TextStyle(color: Colors.green),
            openIcon: Icon(
              Icons.arrow_drop_down,
              color: Colors.pink,
            ),
            closeIcon: Icon(
              Icons.arrow_drop_up,
              color: Colors.pink,
            ),
            separator: Text(
              ': ',
            ),
            intStyle: TextStyle(color: Colors.brown),
            stringStyle: TextStyle(color: Colors.indigo),
            viewType: JsonViewType.collapsible),
      );
    }
    return Text(requestModel.response?.data.toString() ?? '');
  }

  String normalizeMap(Map map) {
    return map.entries.map((e) => '${e.key}: ${e.value}').join('\n').toString();
  }

  Map? parseQueryParameters(RequestModel requestModel) {
    return requestModel.requestOptions.queryParameters.isNotEmpty
        ? requestModel.requestOptions.queryParameters
        : requestModel.response?.realUri.queryParameters;
  }

  Widget buildOverView() {
    return ValueListenableBuilder(
        valueListenable: apiRequests.listenable,
        builder: (context, List<RequestModel> value, c) {
          return ListView.separated(
            itemCount: value.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              final RequestModel requestModel = value[index];
              return ListTile(
                dense: true,
                title: Text(requestModel.requestOptions.path),
                onTap: () {
                  _navigatorKey.currentState!
                      .pushNamed('/details', arguments: requestModel);
                },
                trailing: const Icon(Icons.arrow_forward_ios),
                subtitle: Row(
                  children: [
                    Text('Method: ${requestModel.requestOptions.method}'),
                    Text.rich(TextSpan(children: [
                      const TextSpan(text: '  Status: '),
                      TextSpan(
                          text: "${requestModel.response?.statusCode ?? "--"}",
                          style: TextStyle(
                              color: requestModel.response?.statusCode == 200
                                  ? Colors.green
                                  : Colors.red))
                    ])),
                  ],
                ),
              );
            },
          );
        });
  }
}

class ApiLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    apiRequests.addItem(RequestModel(requestOptions: options));
    handler.next(options);

    // apiRequests.add(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var index = apiRequests.list.indexWhere(
      (element) => element.requestOptions == response.requestOptions,
    );
    apiRequests.replaceAt(
        index,
        RequestModel(
            requestOptions: response.requestOptions, response: response));
    handler.next(response);
  }
}
