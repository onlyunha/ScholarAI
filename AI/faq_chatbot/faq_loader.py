import json

def load_faq_json(path="data/faq.json"):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def filter_faq_by_category(faq_list, category):
    return [faq for faq in faq_list if faq["분류"] == category]