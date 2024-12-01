build:
	lessc static/less/index.less static/index.css
	cd blog && bundle install && bundle exec jekyll build && cd ..
	cp -r blog/_site/* static/blog/
	# cargo build will then run automatically if using cargo run
