import 'package:flutter/material.dart';
import '../service/api_service.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _prizePoolController = TextEditingController();
  final TextEditingController _maxPlayersController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  bool _isLoading = false; // 🔄 Loading state
  String? _errorMessage;   // ❌ Error message

  // Function to create tournament
  void createTournament() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Map<String, dynamic> data = {
      "title": _titleController.text,
      "gameName": _gameNameController.text,
      "entryFee": int.tryParse(_entryFeeController.text) ?? 0,
      "prizePool": int.tryParse(_prizePoolController.text) ?? 0,
      "maxPlayers": int.tryParse(_maxPlayersController.text) ?? 0,
      "startTime": _startTimeController.text,
    };

    try {
      bool success = await ApiService.addTournament(data);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tournament created successfully!")),
        );
        _formKey.currentState!.reset();
      } else {
        setState(() {
          _errorMessage = "Failed to create tournament. Server rejected the request.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error creating tournament: $e";
      });
    } finally {
      setState(() {
        _isLoading = false; // ✅ Stop spinner
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _gameNameController.dispose();
    _entryFeeController.dispose();
    _prizePoolController.dispose();
    _maxPlayersController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Tournament"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter title" : null,
              ),
              TextFormField(
                controller: _gameNameController,
                decoration: const InputDecoration(labelText: "Game Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter game name" : null,
              ),
              TextFormField(
                controller: _entryFeeController,
                decoration: const InputDecoration(labelText: "Entry Fee"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter entry fee" : null,
              ),
              TextFormField(
                controller: _prizePoolController,
                decoration: const InputDecoration(labelText: "Prize Pool"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter prize pool" : null,
              ),
              TextFormField(
                controller: _maxPlayersController,
                decoration: const InputDecoration(labelText: "Max Players"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter max players" : null,
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                    labelText: "Start Time (YYYY-MM-DDTHH:MM:SSZ)"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter start time" : null,
              ),
              const SizedBox(height: 20),

              // 🔄 Loading / Error / Button
              _isLoading
                  ? Center(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text("Creating tournament..."),
                        ],
                      ),
                    )
                  : _errorMessage != null
                      ? Column(
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: createTournament,
                              child: const Text("Retry"),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: createTournament,
                          child: const Text("Create Tournament"),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}