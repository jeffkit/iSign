import os
from flask import Flask, request, redirect, url_for
from werkzeug import secure_filename

PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))
UPLOAD_FOLDER =  os.path.join(PROJECT_ROOT,'photos')
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        print 'post a file'
        file = request.files['file']
        if file and allowed_file(file.filename):
            print 'is a allowed file'
            filename = secure_filename(file.filename)
            print filename
            print 'before saving a file'
            file.save(os.path.join(UPLOAD_FOLDER, filename))
            print 'after save a file'
            return "SUCCESS"

    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form action="" method=post enctype=multipart/form-data>
      <p><input type=file name=file>
         <input type=submit value=Upload>
    </form>
    '''
if __name__ == '__main__':
    app.run()
