import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/subscription_service.dart';
import 'api_service.dart';

void main() {
  runApp(const WeatherDashboard());
}

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  _WeatherDashboardState createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final ApiService apiService = ApiService();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  //final SubscriptionService subscriptionService = SubscriptionService();
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? forecastData;
  bool isLoading = false;
  bool showMoreDays = false;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    fetchWeather("London");
  }

  Future<void> fetchWeather(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = await apiService.fetchWeather(query);
      var forecast = await apiService.fetchForecast(query);
      setState(() {
        weatherData = data;
        forecastData = forecast;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  Future<void> fetchCurrentLocationWeather() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String query = "${position.latitude},${position.longitude}";
      fetchWeather(query);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Dashboard', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue[800],
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return isWideScreen
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildSearchSection()),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: _buildWeatherSection(isWideScreen)),
                        ],
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSearchSection(),
                          const SizedBox(height: 16),
                          _buildWeatherSection(isWideScreen),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  /// Giao diện tìm kiếm
  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AutoSizeText('Enter a City Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1),
        const SizedBox(height: 8),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            hintText: 'E.g., New York, London, Tokyo',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: () => fetchWeather(cityController.text),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const AutoSizeText('Search', style: TextStyle(color: Colors.white), maxLines: 1),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: fetchCurrentLocationWeather,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const AutoSizeText('Use Current Location', style: TextStyle(color: Colors.white), maxLines: 1),
        ),
        const SizedBox(height: 16),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        //   onPressed: () async {
        //     String email = emailController.text.trim();
        //     if (email.isNotEmpty && email.contains("@")) {
        //       await subscriptionService.subscribe(email);
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text("Confirmation email sent to $email")),
        //       );
        //     } else {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text("Please enter a valid email")),
        //       );
        //     }
        //   },
        //   child: const Text("Subscribe to Daily Forecast", style: TextStyle(color: Colors.white)),
        // ),
      ],
    );
  }

  /// Giao diện hiển thị dữ liệu thời tiết
  Widget _buildWeatherSection(bool isWideScreen) {
    if (weatherData == null || forecastData == null) {
      return const Center(child: AutoSizeText('No Data Available', style: TextStyle(fontSize: 18), maxLines: 1));
    }

    var location = weatherData!["location"];
    var current = weatherData!["current"];
    List forecastDays = forecastData!["forecast"]["forecastday"];
    List visibleDays = showMoreDays ? forecastDays : forecastDays.sublist(0, 4); // ✅ Kiểm soát số ngày hiển thị

    return Column(
      children: [
        /// 🔹 **Thời tiết ngày hiện tại**
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText('${location["name"]} (${location["localtime"].split(" ")[0]})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1),
                  AutoSizeText('Temperature: ${current["temp_c"]}°C', style: const TextStyle(color: Colors.white), maxLines: 1),
                  AutoSizeText('Wind: ${current["wind_kph"]} km/h', style: const TextStyle(color: Colors.white), maxLines: 1),
                  AutoSizeText('Humidity: ${current["humidity"]}%', style: const TextStyle(color: Colors.white), maxLines: 1),
                ],
              ),
              Column(
                children: [
                  Image.network("https:${current["condition"]["icon"]}", width: 50, height: 50),
                  AutoSizeText(current["condition"]["text"], style: const TextStyle(color: Colors.white), maxLines: 1),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        /// 🔹 **Dự báo các ngày tiếp theo**
        AutoSizeText(showMoreDays ? '14-Day Forecast' : '4-Day Forecast', 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1),
        const SizedBox(height: 8),

        isWideScreen
            ? SizedBox(
                height: 240, // ✅ Giữ item không bị thu nhỏ
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: visibleDays
                      .map((day) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _buildForecastItem(day),
                          ))
                      .toList(),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.35,
                ),
                itemCount: visibleDays.length,
                itemBuilder: (context, index) => _buildForecastItem(visibleDays[index]),
              ),

        /// 🔹 **Nút More**
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showMoreDays = !showMoreDays; // ✅ Toggle giữa 4 ngày và 14 ngày
            });
          },
          child: Text(showMoreDays ? "Show Less" : "More"),
        ),
      ],
    );
  }
  Widget _buildForecastItem(dynamic day) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(day["date"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
          Image.network("https:${day["day"]["condition"]["icon"]}", width: 50, height: 50),
          AutoSizeText("Temp: ${day["day"]["avgtemp_c"]}°C", maxLines: 1),
          AutoSizeText("Wind: ${day["day"]["maxwind_kph"]} km/h", maxLines: 1),
          AutoSizeText("Humidity: ${day["day"]["avghumidity"]}%", maxLines: 1),
        ],
      ),
    );
  }
}
