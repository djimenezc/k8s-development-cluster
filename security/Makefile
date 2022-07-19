URL ?= https://couponbeard.com/thulium

ENABLE_AUTOMATION_FRAMEWORK ?= true

AUTOMATION_FRAMEWORK_PARAM = $(shell test $(ENABLE_AUTOMATION_FRAMEWORK) == 'true' && echo '--autoof' || echo '')

zap-run-scan:
	docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py \
		-t $(URL) -j '$(AUTOMATION_FRAMEWORK_PARAM)' -g gen.conf -r testreport.html
