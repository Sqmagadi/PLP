from datetime import datetime, timezone
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100)
    
    def __str__(self):
        return self.name
    
    class Meta:
        verbose_name_plural = 'categories'
        
class Specification(models.Model):
    name = models.CharField(max_length=255, blank=True)
    value = models.CharField(max_length=255, blank=True)

    def __str__(self):
        return f"{self.name}: {self.value}"

class Product(models.Model):
    name = models.CharField(max_length=255)
    price = models.DecimalField(default=0, max_digits=9, decimal_places=2)
    category = models.ManyToManyField(Category, default=1)
    description = models.TextField(null=True, blank=True)
    image = models.ImageField(upload_to='uploads/products/')
    is_sale = models.BooleanField(default=False)
    sale_price = models.DecimalField(default=0, decimal_places=2, max_digits=8, null=True, blank=True)
    in_stock = models.BooleanField(default=True)
    stock_quantity = models.IntegerField(default=1)
    discount = models.DecimalField(default=0, max_digits=9, decimal_places=2, null=True, blank=True)
    percentage_discount = models.DecimalField(default=0, max_digits=5, decimal_places=0, null=True, blank=True)
    is_new = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    is_listed = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=datetime.now)
    specification = models.ManyToManyField(Specification, blank=True, default=1, null=True)
    

    def save(self, *args, **kwargs):
        if self.created_at >= timezone.now() - timezone.timedelta(minutes=1):
            self.is_new = False
        else:
            self.is_new = True
            
        
        if self.stock_quantity == 0:
            self.in_stock = False
        else:
            self.in_stock = True
            
       
        if self.is_sale and self.sale_price < self.price:
            self.discount = round(self.price - self.sale_price, 2)
            self.percentage_discount = round((self.discount / self.price) * 100)
        else:
            self.discount = 0
            self.percentage_discount = 0
        super().save(*args, **kwargs)
        
    def __str__(self):
        return self.name
        
    @property
    def imageURL(self):
        try:
            url = self.image.url
        except:
            url = ''
        return url
    
 
class ProductImage(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, default=1)
    image = models.FileField(upload_to='uploads/products/', max_length=12, null=True)
    
    class Meta:
        verbose_name_plural = 'Product Images'
    
    
    def __str__(self):
        return self.id
    
    @property
    def imageURL(self):
        try:
            url = self.image.url
        except:
            url = ''
        return url