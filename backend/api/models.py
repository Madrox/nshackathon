from django.db import models

# Create your models here.




class Spot(models.Model):
	public_id = models.CharField(max_length=100)
	latitude = models.DecimalField(max_digits=10,decimal_places=5)
	longitude = models.DecimalField(max_digits=10,decimal_places=5)
	image = models.URLField(max_length=600)
	owner_token = models.CharField(max_length=100)
	last_ping = models.DateTimeField(auto_now_add=True)
	username = models.CharField(max_length=100)

	def generate(self):
		import uuid
		self.public_id = str(uuid.uuid1())
		self.owner_token = str(uuid.uuid1())


class Share(models.Model):
	link = models.URLField(max_length=600)
	name = models.CharField(max_length=200)
	spot = models.ForeignKey(Spot)


