## Web app (quick tour)

- **Framework:** Flask (single file `app.py`)
- **Port:** `5007` (binds `0.0.0.0`)
- **Templates:** `templates/home.html`, `templates/hello.html`, `templates/404.html`
- **Themes:** one of `HELLO_THEMES` is picked at random per request to style the page.

### Routes
- `GET /`  
  Renders the home page with a simple form.
- `POST /`  
  Reads `name` from the form and redirects to `/hello/<name>`.
- `GET /hello/<name>`  
  Personalized greeting. Special messages for `Shay`; otherwise “Hello, <Name>!”.  
  Example: `/hello/Noy` → contains “Hello, Noy”.
- Custom `404` → themed error page.

### Quick smoke (curl)
```bash
curl -i http://localhost:5007/
curl -i http://localhost:5007/hello/Shay
curl -i http://localhost:5007/hello/Noy
curl -i -o /dev/null -w "%{http_code}\n" http://localhost:5007/shay   # expect 404
```