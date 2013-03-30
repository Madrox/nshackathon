from datetime import datetime
import traceback
from django.http import HttpResponse, HttpResponseServerError
from django.core.serializers import serialize
from django.db.models.query import QuerySet

import json
from django.utils.functional import Promise
from django.utils.encoding import force_text

class LazyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, QuerySet):
            # `default` must return a python serializable
            # structure, the easiest way is to load the JSON
            # string produced by `serialize` and return it
            return json.loads(serialize('json', obj))
        elif isinstance(obj, Promise):
            return force_text(obj)
        return super(LazyEncoder, self).default(obj)


def api_view(func,show_run_time=True,usage=None):
	def view(request,*args,**kwargs):
		response_type = HttpResponse
		mime_type = 'application/json'
		start = datetime.now()
		try:
			result = func(request,*args,**kwargs)
			if result is None:
				result = {}
			elif not isinstance(result,dict):
				result = { 'data': result }
		except:
			response_type = HttpResponseServerError
			result = {
				'exception': traceback.format_exc()
			}
		run_time = (datetime.now()-start).total_seconds()
		if show_run_time: result['run_time'] = run_time
		if usage: result['usage'] = usage

		body = json.dumps(result,indent=2,cls=LazyEncoder)

		if 'callback' in request.GET:
			body = "{callback}({json})".format(
				callback=request.GET['callback'],
				json=body
				)
			mime_type = "application/javascript"

		return response_type(body,content_type=mime_type)

	view.function = func

	return view