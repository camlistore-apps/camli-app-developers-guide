OUT_DIR=./out/
GIT_REPO := git@github.com:camlistore-apps/guide.git
GIT_PUBLISH_BRANCH := gh-pages

all: pull compile

%.html: %.org
	emacs $< --batch -f org-html-export-to-html --kill

FILES=$(patsubst %.org,$(OUT_DIR)/%.html,$(wildcard *.org))
compile: $(OUT_DIR) $(FILES)

$(OUT_DIR)/%.html: %.html
	mv $< $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR)

$(OUT_DIR):
	git clone -b $(GIT_PUBLISH_BRANCH) --single-branch $(GIT_REPO) $(OUT_DIR)

pull: $(OUT_DIR)
	cd $(OUT_DIR) && git pull

publish: pull compile
	-cd $(OUT_DIR) && git add -A . && git commit -m "Publish" && git push
