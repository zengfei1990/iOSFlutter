import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CrossPlatformApp());
}

class CrossPlatformApp extends StatelessWidget {
  const CrossPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learning Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7490)),
        useMaterial3: true,
      ),
      initialRoute: '/learning',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/learning':
            return MaterialPageRoute<void>(
              builder: (_) => const LearningHomePage(),
              settings: settings,
            );
          case '/about-host':
            return MaterialPageRoute<void>(
              builder: (_) => const HostIntegrationPage(),
              settings: settings,
            );
          case '/profile-form':
            return MaterialPageRoute<void>(
              builder: (_) => const ProfileFormPage(),
              settings: settings,
            );
          default:
            return MaterialPageRoute<void>(
              builder: (_) => UnknownRoutePage(routeName: settings.name ?? 'unknown'),
              settings: settings,
            );
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LearningHomePage extends StatefulWidget {
  const LearningHomePage({super.key});

  @override
  State<LearningHomePage> createState() => _LearningHomePageState();
}

class _LearningHomePageState extends State<LearningHomePage> {
  static const MethodChannel _hostChannel = MethodChannel(
    'com.huami.ios_flutter/demo',
  );

  int completedTopics = 1;
  int hostSyncCount = 0;
  String hostPlatform = 'Unknown';
  String hostMessage = 'No native payload received yet.';

  final List<LearningTopic> topics = const [
    LearningTopic(
      title: 'Single codebase',
      description: 'Use one Dart UI layer to target iOS, Android, and Web.',
      icon: Icons.devices_outlined,
    ),
    LearningTopic(
      title: 'Adaptive widgets',
      description: 'Mix Material and Cupertino widgets based on platform.',
      icon: Icons.widgets_outlined,
    ),
    LearningTopic(
      title: 'Hot reload',
      description: 'Edit UI quickly and see the result almost immediately.',
      icon: Icons.bolt_outlined,
    ),
    LearningTopic(
      title: 'Native access',
      description: 'Call platform code later with plugins or method channels.',
      icon: Icons.settings_ethernet_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _hostChannel.setMethodCallHandler(_handleHostMethodCall);
    _loadHostSummary();
  }

  @override
  void dispose() {
    _hostChannel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platformLabel = _platformLabel();
    final bool useCupertinoTone = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Flutter Cross-Platform'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                platformLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PlatformSummaryCard(
            platformLabel: platformLabel,
            completedTopics: completedTopics,
          ),
          const SizedBox(height: 12),
          HostBridgeCard(
            hostPlatform: hostPlatform,
            hostSyncCount: hostSyncCount,
            hostMessage: hostMessage,
            onRefreshFromHost: _loadHostSummary,
            onShowNativeNotice: _showNativeNotice,
            onCloseFlutterPage: _closeFlutterPage,
          ),
          const SizedBox(height: 20),
          Text(
            'Why Flutter',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter is a good cross-platform starting point because the UI, state, and most business logic can stay in one shared codebase.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Core learning topics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TopicCard(topic: topic),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: useCupertinoTone
                ? CupertinoButton.filled(
                    key: const ValueKey('cupertino-button'),
                    onPressed: _markNextTopicDone,
                    child: const Text('Mark next topic done'),
                  )
                : FilledButton.icon(
                    key: const ValueKey('material-button'),
                    onPressed: _markNextTopicDone,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark next topic done'),
                  ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/about-host');
            },
            child: const Text('See host integration notes'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/profile-form');
            },
            child: const Text('Open Flutter form flow'),
          ),
        ],
      ),
    );
  }

  void _markNextTopicDone() {
    if (completedTopics >= topics.length) {
      return;
    }

    setState(() {
      completedTopics += 1;
    });
  }

  Future<void> _loadHostSummary() async {
    try {
      final summary = await _hostChannel.invokeMapMethod<String, dynamic>(
        'getHostSummary',
      );
      _applyHostSummary(summary);
    } on PlatformException {
      if (!mounted) {
        return;
      }
      setState(() {
        hostMessage = 'Failed to fetch native host summary.';
      });
    }
  }

  Future<void> _showNativeNotice() async {
    try {
      await _hostChannel.invokeMethod<String>('showNativeNotice', {
        'message': 'Flutter called into native iOS successfully.',
      });
    } on PlatformException {
      if (!mounted) {
        return;
      }
      setState(() {
        hostMessage = 'Native notice failed to display.';
      });
    }
  }

  Future<void> _closeFlutterPage() async {
    try {
      await _hostChannel.invokeMethod<String>('closeFlutterPage');
    } on PlatformException {
      if (!mounted) {
        return;
      }
      setState(() {
        hostMessage = 'Flutter could not request page close.';
      });
    }
  }

  Future<void> _handleHostMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'hostCounterUpdated':
        final arguments = Map<String, dynamic>.from(
          (call.arguments as Map?) ?? const <String, dynamic>{},
        );
        if (!mounted) {
          return;
        }
        setState(() {
          hostSyncCount = (arguments['hostSyncCount'] as num?)?.toInt() ?? hostSyncCount;
          hostPlatform = arguments['hostPlatform'] as String? ?? hostPlatform;
          hostMessage = arguments['hostMessage'] as String? ?? hostMessage;
        });
        return;
      default:
        return;
    }
  }

  void _applyHostSummary(Map<String, dynamic>? summary) {
    if (!mounted || summary == null) {
      return;
    }

    setState(() {
      hostSyncCount = (summary['hostSyncCount'] as num?)?.toInt() ?? hostSyncCount;
      hostPlatform = summary['hostPlatform'] as String? ?? hostPlatform;
      hostMessage = summary['hostMessage'] as String? ?? hostMessage;
    });
  }

  String _platformLabel() {
    if (kIsWeb) {
      return 'Web';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }
}

class PlatformSummaryCard extends StatelessWidget {
  const PlatformSummaryCard({
    super.key,
    required this.platformLabel,
    required this.completedTopics,
  });

  final String platformLabel;
  final int completedTopics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current platform: $platformLabel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Completed topics: $completedTopics / 4',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'This card is shared across every platform. Only small interaction details need to adapt when the target changes.',
            ),
          ],
        ),
      ),
    );
  }
}

class HostBridgeCard extends StatelessWidget {
  const HostBridgeCard({
    super.key,
    required this.hostPlatform,
    required this.hostSyncCount,
    required this.hostMessage,
    required this.onRefreshFromHost,
    required this.onShowNativeNotice,
    required this.onCloseFlutterPage,
  });

  final String hostPlatform;
  final int hostSyncCount;
  final String hostMessage;
  final Future<void> Function() onRefreshFromHost;
  final Future<void> Function() onShowNativeNotice;
  final Future<void> Function() onCloseFlutterPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Host bridge demo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Native platform: $hostPlatform'),
            Text('Host sync count: $hostSyncCount'),
            const SizedBox(height: 8),
            Text(hostMessage),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: onRefreshFromHost,
                  child: const Text('Read native state'),
                ),
                OutlinedButton(
                  onPressed: onShowNativeNotice,
                  child: const Text('Show native alert'),
                ),
                OutlinedButton(
                  onPressed: onCloseFlutterPage,
                  child: const Text('Ask host to close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  static const MethodChannel _hostChannel = MethodChannel(
    'com.huami.ios_flutter/demo',
  );

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  String _selectedRole = 'iOS Developer';
  bool _newsletterEnabled = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Form Flow')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'This page simulates a real add-to-app form flow: native opens Flutter, Flutter collects input, then sends the result back to native.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'iOS Developer',
                  child: Text('iOS Developer'),
                ),
                DropdownMenuItem(
                  value: 'Flutter Developer',
                  child: Text('Flutter Developer'),
                ),
                DropdownMenuItem(
                  value: 'Product Designer',
                  child: Text('Product Designer'),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Learning goal',
                hintText: 'For example: Understand add-to-app and method channels',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a learning goal';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subscribe to Flutter updates'),
              value: _newsletterEnabled,
              onChanged: (value) {
                setState(() {
                  _newsletterEnabled = value;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _submitToHost,
              child: Text(_isSubmitting ? 'Submitting...' : 'Submit to native host'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitToHost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _hostChannel.invokeMethod<String>('submitProfileForm', {
        'name': _nameController.text.trim(),
        'role': _selectedRole,
        'goal': _goalController.text.trim(),
        'newsletterEnabled': _newsletterEnabled,
      });
      await _hostChannel.invokeMethod<String>('closeFlutterPage');
    } on PlatformException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send the form result to native host.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.topic,
  });

  final LearningTopic topic;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(topic.icon),
        title: Text(topic.title),
        subtitle: Text(topic.description),
      ),
    );
  }
}

class HostIntegrationPage extends StatelessWidget {
  const HostIntegrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host Integration')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'This page is useful in add-to-app mode. The iOS host can open Flutter with the /learning route first, then Flutter can navigate to more shared pages on its own.',
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.route_outlined),
              title: Text('Initial route'),
              subtitle: Text('/learning is currently sent from the iOS host app.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.memory_outlined),
              title: Text('Shared engine'),
              subtitle: Text('The host app is prepared to reuse one FlutterEngine.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.swap_horiz_outlined),
              title: Text('Next step'),
              subtitle: Text('Add method channels or plugins when you need native capabilities.'),
            ),
          ),
        ],
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({
    super.key,
    required this.routeName,
  });

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown Route')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Flutter received an unknown route: $routeName',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LearningTopic {
  const LearningTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
