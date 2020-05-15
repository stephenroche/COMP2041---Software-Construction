#!/web/cs2041/bin/python3.6.3

# Written by stephen.roche00@gmail.com October 2017
# for COMP[29]041 assignment 2
# https://cgi.cse.unsw.edu.au/~cs2041/assignments/UNSWtalk/

# Implementation of UNSWtalk social media platform
# Contains a login page, newsfeed, profiles, and a search capability
# All of the data containing user details, posts, friends, etc. is stored in a large dict called data

import os
from flask import Flask, render_template, session, url_for, request, redirect
import pickle, glob, re, datetime, time, cgi

# Set which dataset is used
dataset = "static/dataset-medium";

app = Flask(__name__)

# Format time in posts
def process_time(time):
   time = re.sub('\+.*', '', time)
   return re.sub('T', ' ', time)
   
# Function used to build data dict from dataset-*
# Should only be run once on first request
def readData():
   data = {}
   # Iterate through each user
   for zid in os.listdir(dataset):
      data[zid] = {}
      # Read student details
      for line in open(os.path.join(dataset, zid, 'student.txt')):
         match = re.match('full_name: (.*\S)', line)
         if (match):
            data[zid]['name'] = match.group(1)
         
         match = re.match('program: (.*\S)', line)
         if (match):
            data[zid]['program'] = match.group(1)
         
         match = re.match('email: (.*\S)', line)
         if (match):
            data[zid]['email'] = match.group(1)
         
         match = re.match('birthday: (.*\S)', line)
         if (match):
            data[zid]['birthday'] = match.group(1)
         
         match = re.match('password: (.*\S)', line)
         if (match):
            data[zid]['password'] = match.group(1)
         
         match = re.match('home_suburb: (.*\S)', line)
         if (match):
            data[zid]['home_suburb'] = match.group(1)
         
         match = re.match('home_latitude: (.*\S)', line)
         if (match):
            data[zid]['home_latitude'] = float(match.group(1))
         
         match = re.match('home_longitude: (.*\S)', line)
         if (match):
            data[zid]['home_longitude'] = float(match.group(1))
         
         match = re.match('friends: \((.*)\)', line)
         if (match):
            data[zid]['friends'] = match.group(1).split(', ')
         
         match = re.match('courses: \((.*)\)', line)
         if (match):
            data[zid]['courses'] = match.group(1).split(', ')


      # Read posts hosted by this student
      # (posts on their wall)
      data[zid]['posts'] = {}
      for post in reversed(sorted(glob.glob(os.path.join(dataset, zid, r'*.txt')))):
         # Match 1-3-4.txt format of file names
         match = re.search(r'/(\d+)(?:\-(\d+))?(?:\-(\d+))?\.txt$', post)
         if not match:
            continue

         # Posts
         if not match.group(2):
            data[zid]['posts'][match.group(1)] = {}
            data[zid]['posts'][match.group(1)]['comments'] = {}
            data[zid]['posts'][match.group(1)]['num'] = match.group(1)
            data[zid]['posts'][match.group(1)]['host'] = zid
            for line in open(post):
               matchL = re.match('(from|message|time): (.*?)\s*$', line)
               if (matchL and matchL.group(1) == 'from'):
                  data[zid]['posts'][match.group(1)]['from'] = matchL.group(2)
               elif (matchL and matchL.group(1) == 'message'):
                  data[zid]['posts'][match.group(1)]['message'] = re.sub(r'\\n', r'\n', matchL.group(2))
               elif (matchL and matchL.group(1) == 'time'):
                  data[zid]['posts'][match.group(1)]['time'] = process_time(matchL.group(2))
                  
         # Comments
         elif not match.group(3):
            data[zid]['posts'][match.group(1)]['comments'][match.group(2)] = {}
            data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['replies'] = {}
            for line in open(post):
               matchL = re.match('(from|message|time): (.*?)\s*$', line)
               if (matchL and matchL.group(1) == 'from'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['from'] = matchL.group(2)
               elif (matchL and matchL.group(1) == 'message'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['message'] = re.sub(r'\\n', r'\n', matchL.group(2))
               elif (matchL and matchL.group(1) == 'time'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['time'] = process_time(matchL.group(2))
         
         # Replies
         else:
            data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['replies'][match.group(3)] = {}
            for line in open(post):
               matchL = re.match('(from|message|time): (.*?)\s*$', line)
               if (matchL and matchL.group(1) == 'from'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['replies'][match.group(3)]['from'] = matchL.group(2)
               elif (matchL and matchL.group(1) == 'message'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['replies'][match.group(3)]['message'] = re.sub(r'\\n', r'\n', matchL.group(2))
               elif (matchL and matchL.group(1) == 'time'):
                  data[zid]['posts'][match.group(1)]['comments'][match.group(2)]['replies'][match.group(3)]['time'] = process_time(matchL.group(2))

   return data
   
# Assemble data dict for use by any other functions

# On first request data is built using getData() and
# then immediately pickled into the pickled_data file
# in the home directory

# From then on, only the data dict is modified and the
# original dataset-* files are left unchanged

# On any later requests, data is unpickled from the
# pickled_data file, which is much quicker than rebuilding
# it from dataset-* using getdata()
if (glob.glob('pickled_data')):
   data = pickle.load(open('pickled_data', 'rb'))
else:
   data = readData()
   pickle.dump(data, open('pickled_data', 'wb'))   
   
# Function used within repl_tags() function (below) to
# Replace zids of UNSWtalk students in posts/comments/
# replies with their name and a link to their profile
# Invalid zids are left unlinked but bold
def zidrepl(match):
   tag_zid = match.group(0)
   if tag_zid not in data:
      return '<b>'+tag_zid+'</b>'
   
   return r'<a href="{0}">{1}</a>'.format(url_for('profile', zid=tag_zid), data[tag_zid]["name"])
   
# Custom Jinja filter to replace zids of UNSWtalk
# students in posts/comments/replies with their name and
# a link to their profile
# Any other html is escaped before replacing with links
def repl_tags(message=''):
   message = cgi.escape(str(message))
   return re.sub(r'z\d{7}', zidrepl, message)
   
app.jinja_env.filters['repl_tags'] = repl_tags


if __name__ == '__main__':
   app.secret_key = os.urandom(12)
   app.run(debug=True)


# Home page
# Users start here
# Redirects to login if no user is logged in, otherwise
# redirects to their newsfeed
@app.route('/', methods=['GET', 'POST'])
def home():
   # Initialise dataset cookie for use in Jinja
   # templates
   session['dataset'] = re.sub('static/', '', dataset) + '/'

   if (session.get('zid', '') == ''):
      return redirect(url_for('login'))
   else:
      return redirect(url_for('newsfeed'))


# Login page
# Checks zid and password against know users
@app.route('/login', methods=['GET', 'POST'])
def login():
   if (request.method == 'GET' and session.get('zid', '')):
      return redirect(url_for('profile', zid=session['zid']))
   
   # Pop current user cookie (logout button POSTs to this
   # page)
   session.pop('zid', None)

   zid = request.form.get('zid', '')
   password = request.form.get('password', '')
   zid = re.sub(r'\W', '', zid)

   if zid == '':
      return render_template('login.html')
   elif zid not in data:
      return render_template('login.html', error = 'unknown zid - do you have a UNSWtalk account?')
   elif password != data[zid]['password']:
      return render_template('login.html', error = 'incorrect password')
   
   # Store current user zid in session cookie
   session['zid'] = zid
   
   return redirect(url_for('home'))


# Search page
# Returns a list of users that contain a query substring
# Also returns a list of posts that contain a query word
@app.route('/search', methods=['GET', 'POST'])
def search(query=''):
   query = request.form.get('query', '')
   if not query:
      return redirect(url_for('home'))
   
   user_hits = []
   post_hits = []
   
   # Search users
   for user in data:
      if query.lower() in data[user]['name'].lower():
         user_hits.append(user)
   
      # Search posts
      for post in data[user]['posts']:
         if (re.search(r'\b'+query+r'\b', data[user]['posts'][post]['message'], re.IGNORECASE)):
            post_hits.append(data[user]['posts'][post])
   
   # Sort posts by reverse chronological order
   post_hits = sorted(post_hits, key=lambda post: post['time'], reverse=True)
   
   # Print errors if no hits found
   no_users = no_posts = ''
   if not user_hits:
      no_users = "No users matched your search query"
   if not post_hits:
      no_posts = "No posts matched your search query"

   return render_template('search.html', user_hits=user_hits, post_hits=post_hits, query=query, data=data, no_users=no_users, no_posts=no_posts)


# Profile page
# Contains profile picture, student details, friend list
# and posts to their wall
# Users are able to delete any posts on their own wall,
# not just posts they've made, but only their own comments
# and replies
@app.route('/profile/<zid>', methods=['GET', 'POST'])
def profile(zid):
   # Public student details
   details = []
   if 'program' in data[zid]:
      details.append(('Program: ', data[zid]['program']))
   if 'home_suburb' in data[zid]:
      details.append(('Suburb: ', data[zid]['home_suburb']))
   if 'birthday' in data[zid]:
      details.append(('Birthday: ', data[zid]['birthday']))
   if 'courses' in data[zid]:
      details.append(('Courses: ', ', '.join(reversed(data[zid]['courses']))))
      
   # Delete posts
   if (request.form.get('form_action', '') == 'del_post'):
      (par_zid, post_num) = request.form['to_del'].split('-')
      data[par_zid]['posts'].pop(post_num, None)
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Delete comments
   if (request.form.get('form_action', '') == 'del_comment'):
      (par_zid, post_num, comment) = request.form['to_del'].split('-')
      data[par_zid]['posts'][post_num]['comments'].pop(comment, None)
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Delete replies
   if (request.form.get('form_action', '') == 'del_reply'):
      (par_zid, post_num, comment, reply) = request.form['to_del'].split('-')
      data[par_zid]['posts'][post_num]['comments'][comment]['replies'].pop(reply, None)
      pickle.dump(data, open('pickled_data', 'wb'))      

   # Make a post 
   if (request.form.get('form_action', '') == 'make_post'):
      message = request.form.get('post', '')
      par_zid = request.form['parent']
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_post = -1
      for post in data[par_zid]['posts']:
         if (int(post) > last_post):
            last_post = int(post)
            
      data[par_zid]['posts'][str(last_post+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time, 'comments':{}, 'num':str(last_post+1), 'host':par_zid}
      
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Make comment 
   if (request.form.get('form_action', '') == 'make_comment'):
      message = request.form.get('comment', '')
      (par_zid, par_post) = request.form['parent'].split('-')
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_comment = -1
      for comment in data[par_zid]['posts'][par_post]['comments']:
         if (int(comment) > last_comment):
            last_comment = int(comment)
            
      data[par_zid]['posts'][par_post]['comments'][str(last_comment+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time, 'replies':{}}
      
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Make reply 
   if (request.form.get('form_action', '') == 'make_reply'):
      message = request.form.get('reply', '')
      (par_zid, par_post, par_comment) = request.form['parent'].split('-')
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_reply = -1
      for reply in data[par_zid]['posts'][par_post]['comments'][par_comment]['replies']:
         if (int(reply) > last_reply):
            last_reply = int(reply)
            
      data[par_zid]['posts'][par_post]['comments'][par_comment]['replies'][str(last_reply+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time}
      
      pickle.dump(data, open('pickled_data', 'wb'))
   
   # Make list of posts on wall sorted in reverse
   # chronological order
   posts = sorted(list(data[zid]['posts'].values()), key=lambda post: post['time'], reverse=True)

   return render_template('profile.html', data=data, prof_zid=zid, details=details, friends=data[zid]['friends'], posts=posts)

   

# News feed
# Contains user's posts, friends posts and mentions all
# sorted in reverse chronological order
@app.route('/newsfeed', methods=['GET', 'POST'])
def newsfeed():

   # Delete posts
   if (request.form.get('form_action', '') == 'del_post'):
      (par_zid, post_num) = request.form['to_del'].split('-')
      data[par_zid]['posts'].pop(post_num, None)
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Delete comments
   if (request.form.get('form_action', '') == 'del_comment'):
      (par_zid, post_num, comment) = request.form['to_del'].split('-')
      data[par_zid]['posts'][post_num]['comments'].pop(comment, None)
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Delete replies
   if (request.form.get('form_action', '') == 'del_reply'):
      (par_zid, post_num, comment, reply) = request.form['to_del'].split('-')
      data[par_zid]['posts'][post_num]['comments'][comment]['replies'].pop(reply, None)
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Make a post
   # Posts made while on the newsfeed are posted to the
   # user's own wall
   if (request.form.get('form_action', '') == 'make_post'):
      message = request.form.get('post', '')
      par_zid = request.form['parent']
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_post = -1
      for post in data[par_zid]['posts']:
         if (int(post) > last_post):
            last_post = int(post)
            
      data[par_zid]['posts'][str(last_post+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time, 'comments':{}, 'num':str(last_post+1), 'host':par_zid}
      
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Make comment 
   if (request.form.get('form_action', '') == 'make_comment'):
      message = request.form.get('comment', '')
      (par_zid, par_post) = request.form['parent'].split('-')
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_comment = -1
      for comment in data[par_zid]['posts'][par_post]['comments']:
         if (int(comment) > last_comment):
            last_comment = int(comment)
            
      data[par_zid]['posts'][par_post]['comments'][str(last_comment+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time, 'replies':{}}
      
      pickle.dump(data, open('pickled_data', 'wb'))
      
   # Make reply 
   if (request.form.get('form_action', '') == 'make_reply'):
      message = request.form.get('reply', '')
      (par_zid, par_post, par_comment) = request.form['parent'].split('-')
      time = re.sub('\..*', '', str(datetime.datetime.today()))
      
      last_reply = -1
      for reply in data[par_zid]['posts'][par_post]['comments'][par_comment]['replies']:
         if (int(reply) > last_reply):
            last_reply = int(reply)
            
      data[par_zid]['posts'][par_post]['comments'][par_comment]['replies'][str(last_reply+1)] = {'from':session.get('zid', 'unknown_user'), 'message':message, 'time':time}
      
      pickle.dump(data, open('pickled_data', 'wb'))
   
   # List of posts
   my_posts = list(data[session['zid']]['posts'].values())
   
   friend_posts = []
   
   for friend in data[session['zid']]['friends']:
      friend_posts += list(data[friend]['posts'].values())
   
   posts = my_posts + friend_posts
   
   # Sort posts in reverse chronological order
   posts = sorted(posts, key=lambda post: post['time'], reverse=True)

   return render_template('newsfeed.html', data=data, posts=posts)
