from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    url(r'^identify$', 'api.views.identify', name='identify'),
    url(r'^([\w\d\-]+)$', 'api.views.status', name='status'),
    url(r'^([\w\d\-]+)/stop$', 'api.views.stop_sharing', name='stop'),
    url(r'^([\w\d\-]+)/share$', 'api.views.share', name='share'),

    # url(r'^airdropbox/', include('airdropbox.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
