import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  int completedTopics = 1;

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
