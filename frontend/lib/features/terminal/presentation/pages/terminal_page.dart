import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<_TerminalLine> _lines = [
    const _TerminalLine('CyberVerse Terminal v1.0.0', type: _LineType.system),
    const _TerminalLine('Type "help" for available commands.', type: _LineType.system),
    const _TerminalLine('', type: _LineType.system),
  ];

  static final Map<String, String> _commands = {
    'help': '''Available commands:
  help         - Show this help message
  ls           - List files in current directory
  cat          - Display file contents
  ping         - Ping a host
  nmap         - Simulate network scan
  whois        - Domain information
  whoami       - Show current user
  clear        - Clear terminal
  exit         - Close terminal
  history      - Show command history''',
    'ls': '''-rw-r--r--  1 root  root  4096  /etc/passwd
-rw-r--r--  1 root  root  1024  /var/log/auth.log
drwxr-xr-x  2 root  root  4096  /home/agent/
-rwxr-xr-x  1 root  root  8192  /usr/bin/scanner''',
    'cat /etc/passwd': '''root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
agent:x:1000:1000:CyberVerse Agent:/home/agent:/bin/bash
neo_hacker:x:1001:1001::/home/neo_hacker:/bin/bash''',
    'whoami': 'neo_hacker',
    'ping google.com': '''PING google.com (142.250.185.78): 56 data bytes
64 bytes from 142.250.185.78: icmp_seq=0 ttl=116 time=12.3 ms
64 bytes from 142.250.185.78: icmp_seq=1 ttl=116 time=11.8 ms
64 bytes from 142.250.185.78: icmp_seq=2 ttl=116 time=13.1 ms
--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss''',
    'nmap': '''Starting Nmap 7.93
Nmap scan report for 192.168.1.1
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1
80/tcp   open  http    Apache httpd 2.4.41
443/tcp  open  https   Apache httpd 2.4.41
3306/tcp open  mysql   MySQL 5.7.38

Nmap done: 1 IP address (1 host up) scanned in 2.34 seconds''',
    'whois google.com': '''Domain Name: GOOGLE.COM
Registry Domain ID: 2138514_DOMAIN_COM-VRSN
Registrar: MarkMonitor Inc.
Creation Date: 1997-09-15T04:00:00Z
Registrar URL: http://www.markmonitor.com
Name Server: NS1.GOOGLE.COM
Name Server: NS2.GOOGLE.COM
DNSSEC: unsigned''',
    'history': '''  1  help
  2  ls
  3  whoami
  4  nmap
  5  ping google.com''',
  };

  final List<String> _commandHistory = [];

  void _runCommand(String cmd) {
    cmd = cmd.trim();
    if (cmd.isEmpty) return;
    _commandHistory.insert(0, cmd);
    _inputCtrl.clear();

    setState(() {
      _lines.add(_TerminalLine('\$ $cmd', type: _LineType.input));
      if (cmd == 'clear') {
        _lines.clear();
        return;
      }
      final response = _commands[cmd.toLowerCase()];
      if (response != null) {
        _lines.add(_TerminalLine(response, type: _LineType.output));
      } else {
        _lines.add(_TerminalLine(
          'command not found: $cmd\nTry "help" to see available commands.',
          type: _LineType.error,
        ));
      }
      _lines.add(const _TerminalLine('', type: _LineType.system));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: 200.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                  color: AppColors.error, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                  color: Colors.orange, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            const Text('neo_hacker@cyberverse:~\$',
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: AppColors.primary)),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: _lines.length,
                itemBuilder: (context, i) {
                  final line = _lines[i];
                  return Text(
                    line.text,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.5,
                      color: _getColor(line.type),
                    ),
                  )
                      .animate(key: ValueKey(i))
                      .fadeIn(duration: 100.ms);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF0D0D0D),
              child: Row(
                children: [
                  const Text('\$ ',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.textPrimary,
                          fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter command...',
                        hintStyle: TextStyle(
                            color: Color(0xFF444444),
                            fontFamily: 'monospace',
                            fontSize: 13),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _runCommand,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: AppColors.primary, size: 18),
                    onPressed: () => _runCommand(_inputCtrl.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(_LineType type) {
    switch (type) {
      case _LineType.input:
        return AppColors.primary;
      case _LineType.output:
        return AppColors.textPrimary;
      case _LineType.error:
        return AppColors.error;
      case _LineType.system:
        return const Color(0xFF666666);
    }
  }
}

enum _LineType { input, output, error, system }

class _TerminalLine {
  final String text;
  final _LineType type;

  const _TerminalLine(this.text, {required this.type});
}
