import { MentorAiRepository } from "./mentor_ai.repository";

const mentorAiRepository = new MentorAiRepository();

export class MentorAiService {
  async chat(userId: string, message: string) {
    // Mock response for now. In a real app, you'd call OpenAI/Gemini API here.
    let response = "";
    const msg = message.toLowerCase();

    if (msg.includes("hello") || msg.includes("hi")) {
      response = "Hello! I am your CyberVerse Mentor. How can I help you today?";
    } else if (msg.includes("nmap")) {
      response = "Nmap is a powerful network scanning tool. Try 'nmap -sV <target>' to detect services.";
    } else if (msg.includes("sql injection")) {
      response = "SQL Injection occurs when untrusted data is sent to an interpreter as part of a command or query.";
    } else {
      response = "That's an interesting question. Let's explore the world of cybersecurity together!";
    }

    await mentorAiRepository.saveChat(userId, message, response);
    return { response };
  }

  async getHistory(userId: string) {
    return mentorAiRepository.getChatHistory(userId);
  }
}
