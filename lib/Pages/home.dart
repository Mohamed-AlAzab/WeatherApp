import 'package:flutter/material.dart';
import 'package:weatherapp/API/api.dart';
import 'package:weatherapp/Models/weatherModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/Profile');
          },
          icon: Icon(Icons.account_circle),
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Weather App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/Setting');
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSearchWidget(),
            const SizedBox(height: 12),
            if (inProgress)
              CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: _buildWeatherWidget(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return SearchBar(
      hintText: 'Enter the city...',
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return const Text("Search for the location..");
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.location_on,
                size: 50,
              ),
              Text(
                response?.location?.name ?? "",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                response?.location?.country ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
              ),
              Text(
                (response?.current?.tempC.toString() ?? "") + "°C",
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (response?.current?.condition?.text.toString() ?? ""),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Center(
            child: SizedBox(
              height: 175,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          Card(
            elevation: 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Humidity",
                        "${response?.current?.humidity.toString() ?? ""} "),
                    _dataAndTitleWidget("Wind Speed",
                        "${response?.current?.windKph.toString() ?? ""} Km/h")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget(
                        "Uv", "${response?.current?.uv.toString() ?? ""} "),
                    _dataAndTitleWidget("Percipitation",
                        "${response?.current?.precipMm.toString() ?? ""} mm")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Local Time",
                        "${response?.location!.localtime?.split(" ").last ?? ""} "),
                    _dataAndTitleWidget("Local Date",
                        "${response?.location!.localtime?.split(" ").first ?? ""} ")
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Text(
            data,
            style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
