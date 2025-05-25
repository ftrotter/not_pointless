from django.shortcuts import render
from django.http import HttpResponse
from .models import Endpoint

def homepage(request):
    """
    Display a simple homepage with distinct URLs from the endpoint table
    """
    try:
        # Get distinct endpoint URLs from the database
        distinct_urls = Endpoint.objects.values_list('endpoint_url', flat=True).distinct().order_by('endpoint_url')
        
        context = {
            'urls': distinct_urls,
            'total_count': distinct_urls.count()
        }
        
        return render(request, 'not_pointless/homepage.html', context)
    
    except Exception as e:
        # If there's a database connection issue, show the error
        return HttpResponse(f"Database connection error: {str(e)}", status=500)
