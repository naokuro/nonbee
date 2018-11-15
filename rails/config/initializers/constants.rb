#####################
# define constants
#####################
# Valid Regex
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
VALID_KATA_REGEX = /\A[\p{Katakana}　ー－&&[^ -~｡-ﾟ]]+\z/
VALID_HIRAGANA_REGEX = /\A[\p{Hiragana}]+\z/
VALID_KANJI_REGEX = /\A[\p{Han}]+\z/
VALID_NAME_REGEX = /\A[\p{Katakana}|\p{Hiragana}|\p{Han}|　ー－&&[^ -~｡-ﾟ]]+\z/
VALID_MOBILE_TEL_REGEX = /(?!^([1-9]|00|010|020|030|040|050|060|070|080|090|0120|0570))^[0\d]{10}|^(050|070|080|090)[\d]{8}/
VALID_BIRTHDAY_REGEX = /\A(\d{4})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])\z/
VALID_PASSWORD_REGEX = /\A[\p{ASCII}]+\z/
VALID_SIZE_WRIST_REGEX = /\A\d{1}\z|\A\d{2}\z|\A\d{1}\.\d{1}\z|\A\d{2}\.\d{1}\z/
VALID_FB_ACCOUNT_NAME_REGEX = /\A[a-z0-9.]+\z/i
