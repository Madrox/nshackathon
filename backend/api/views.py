# Create your views here.
from helpers import api_view
from models import *
from django.shortcuts import get_object_or_404
from decimal import Decimal
from django.http import HttpResponse

"""
    url(r'^identify$', 'api.views.identify', name='identify'),
    url(r'^shares_near_me$', 'api.views.shares_near_me', name='near-me'),
    url(r'^(\w\d\-)+$', 'api.views.my_share', name='me'),
    url(r'^(\w\d\-)+/stop$', 'api.views.stop_sharing', name='stop'),
    url(r'^(\w\d\-)+/share$', 'api.views.share', name='share'),
    url(r'^ppl_near_me$', 'api.views.ppl_near_me', name='ppl'),
    """


def identify(request):
	spot = Spot.objects.create(
		latitude=request.REQUEST.get('lat',0.0),
		longitude=request.REQUEST.get('lon',0.0),
		username=request.REQUEST.get('username','Anonymous'),
		image=request.REQUEST.get('image','http://example.com/unknown.jpg'),
		)
	spot.generate()
	spot.save()
	return HttpResponse(spot.owner_token)

@api_view
def status(request,owner_token):
	spot = get_object_or_404(Spot,owner_token=owner_token)
	ppl = Spot.objects.filter(
						latitude__gt=spot.latitude-Decimal(.5)
						).filter(
						latitude__lt=spot.latitude+Decimal(.5)
						).filter(
						longitude__gt=spot.longitude-Decimal(.5)
						).filter(
						longitude__lt=spot.longitude+Decimal(.5)
						)
	shares = Share.objects.filter(spot__in=ppl)
	#ppl = ppl.exclude(id=spot.id)
	return { 
		"shares_near_me": shares,
		"ppl_near_me": ppl,
		"notifications": [
			{ 'id': 1234, 'msg': 'Bob just accepted your share!' }
		]
		}

@api_view
def stop_sharing(request,owner_token):
	spot = get_object_or_404(Spot,owner_token=owner_token)
	share = get_object_or_404(Share,spot=spot)
	share.delete()
	return { "stop_sharing": True }

@api_view #(usage={'name': 'friendly share name', 'link': 'dropbox link'})
def share(request,owner_token):
	spot = get_object_or_404(Spot,owner_token=owner_token)
	share = Share.objects.create(	spot=spot,
									name=request.REQUEST.get('name','share'),
									link=request.REQUEST.get('link','http://foo.com'))
	share.save()
	return { "share": share.id }
