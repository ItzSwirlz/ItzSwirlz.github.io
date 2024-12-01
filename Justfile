build:
	lessc static/less/index.less static/index.css
	cd blog && bundle exec jekyll build && cd ..
	# cargo build will then run automatically
