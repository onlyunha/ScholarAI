from faq_chatbot.faq_loader import load_faq_json, filter_faq_by_category
from faq_chatbot.embedder import FAQEmbedder

class FAQChatBot:
    def __init__(self, faq_path="data/faq.json"):
        self.faq_list = load_faq_json(faq_path)
        self.embedder = FAQEmbedder()

    def get_answer(self, question, category):
        filtered_faqs = filter_faq_by_category(self.faq_list, category)
        if not filtered_faqs:
            return None

        matched = self.embedder.find_best_match(question, filtered_faqs)
        return {
            "id": matched["ID"],
            "matched_question": matched["질문"],
            "answer": matched["답변"]
        }
